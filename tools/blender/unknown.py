"""Builds, rigs, animates and renders Unknown as a 2D silhouette sprite set
(docs/art-pipeline.md §5C). Run headless:

  /Applications/Blender.app/Contents/MacOS/Blender -b -P tools/blender/unknown.py -- \
      --out art-source/work/characters/unknown/renders [--anims walk,idle,look_around] \
      [--dirs r,u,d] [--fps 12] [--blend art-source/work/characters/unknown/unknown.blend]

Motion is keyed at 24 fps; any output rate samples it (between keys too), so
the walk can be compared at 12 and 15 fps from the same keys.

Proportions come from the accepted body sheet (IMG-0004 v4): 1.85 m tall,
0.45 m across the shoulders, narrow waist, long thin limbs. The body is a
skin-modifier skeleton plus a head, rigged with named bones and automatic
weights; motion is keyframed here (decision #23). Renders are pure-black
silhouettes on transparency (Workbench), plus anchors.json with per-frame
pixel positions of the head, eyes, shoulders, upper back, hands and feet.
"""

import argparse
import json
import math
import sys
from pathlib import Path

import bpy
from bpy_extras.object_utils import world_to_camera_view
from mathutils import Euler, Vector

HEIGHT = 1.85
FRAME = (400, 576)  # sprite frame in pixels
CHARACTER_PX = 480  # how tall Unknown is in the frame at scale 1
ORTHO_SCALE = HEIGHT * FRAME[1] / CHARACTER_PX
TILT_DEG = 10.0
CYCLE = 24  # walk cycle length in 24 fps frames (one second)

# Skin skeleton: name -> (position, (radius across, radius depth)).
JOINTS = {
    "pelvis": ((0.0, 0.035, 0.98), (0.13, 0.125)),
    "waist": ((0.0, 0.005, 1.17), (0.1, 0.1)),
    "chest": ((0.0, -0.035, 1.33), (0.13, 0.125)),
    "upper_chest": ((0.0, -0.02, 1.45), (0.12, 0.1)),
    "clavicle.L": ((0.12, -0.005, 1.49), (0.055, 0.055)),
    "neck_base": ((0.0, 0.0, 1.54), (0.05, 0.05)),
    "neck_top": ((0.0, -0.015, 1.665), (0.045, 0.048)),
    "shoulder.L": ((0.18, 0.0, 1.465), (0.05, 0.05)),
    "elbow.L": ((0.25, 0.01, 1.15), (0.034, 0.034)),
    "wrist.L": ((0.295, 0.0, 0.9), (0.026, 0.024)),
    "hand.L": ((0.31, -0.005, 0.765), (0.036, 0.015)),
    "hip.L": ((0.09, 0.02, 0.94), (0.075, 0.075)),
    "knee.L": ((0.1, 0.0, 0.53), (0.048, 0.048)),
    "ankle.L": ((0.1, 0.015, 0.09), (0.03, 0.03)),
    "toe.L": ((0.1, -0.145, 0.025), (0.034, 0.018)),
    "heel.L": ((0.1, 0.05, 0.025), (0.026, 0.02)),
}
for name in list(JOINTS):
    if name.endswith(".L"):
        (x, y, z), radius = JOINTS[name]
        JOINTS[name[:-2] + ".R"] = ((-x, y, z), radius)

EDGES = [
    ("pelvis", "waist"), ("waist", "chest"), ("chest", "upper_chest"), ("upper_chest", "neck_base"), ("neck_base", "neck_top"),
    *[(a + s, b + s) for s in (".L", ".R") for a, b in (("shoulder", "elbow"), ("elbow", "wrist"), ("wrist", "hand"), ("hip", "knee"), ("knee", "ankle"), ("ankle", "toe"), ("ankle", "heel"))],
    ("upper_chest", "clavicle.L"), ("clavicle.L", "shoulder.L"), ("upper_chest", "clavicle.R"), ("clavicle.R", "shoulder.R"), ("pelvis", "hip.L"), ("pelvis", "hip.R"),
]

# Bones: name -> (head, tail, parent).
BONES = {
    "hips": ((0, 0.02, 0.98), (0, 0.005, 1.15), None),
    "spine": ((0, 0.005, 1.15), (0, -0.02, 1.33), "hips"),
    "chest": ((0, -0.02, 1.33), (0, -0.01, 1.52), "spine"),
    "neck": ((0, -0.005, 1.53), (0, -0.015, 1.64), "chest"),
    "head": ((0, -0.015, 1.64), (0, -0.02, 1.85), "neck"),
}
for s, sign in ((".L", 1), (".R", -1)):
    BONES.update({
        "shoulder" + s: ((0.03 * sign, -0.01, 1.48), (0.175 * sign, 0, 1.465), "chest"),
        "upper_arm" + s: ((0.18 * sign, 0, 1.465), (0.25 * sign, 0.01, 1.15), "shoulder" + s),
        "forearm" + s: ((0.25 * sign, 0.01, 1.15), (0.295 * sign, 0, 0.9), "upper_arm" + s),
        "hand" + s: ((0.295 * sign, 0, 0.9), (0.31 * sign, -0.005, 0.77), "forearm" + s),
        "thigh" + s: ((0.09 * sign, 0.02, 0.94), (0.1 * sign, 0, 0.53), "hips"),
        "shin" + s: ((0.1 * sign, 0, 0.53), (0.1 * sign, 0.015, 0.09), "thigh" + s),
        "foot" + s: ((0.1 * sign, 0.015, 0.09), (0.1 * sign, -0.145, 0.025), "shin" + s),
    })


def clear_scene() -> None:
    bpy.ops.wm.read_factory_settings(use_empty=True)


def activate(obj) -> None:
    for other in bpy.context.view_layer.objects:
        other.select_set(False)
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj


def build_body():
    names = list(JOINTS)
    mesh = bpy.data.meshes.new("UnknownBody")
    mesh.from_pydata([JOINTS[n][0] for n in names], [(names.index(a), names.index(b)) for a, b in EDGES], [])
    body = bpy.data.objects.new("UnknownBody", mesh)
    bpy.context.collection.objects.link(body)
    activate(body)
    skin = body.modifiers.new("Skin", "SKIN")
    skin.use_smooth_shade = True
    for index, name in enumerate(names):
        data = mesh.skin_vertices[0].data[index]
        data.radius = JOINTS[name][1]
        data.use_root = name == "pelvis"
    body.modifiers.new("Subdivision", "SUBSURF").levels = 2
    with bpy.context.temp_override(object=body, active_object=body, selected_objects=[body]):
        bpy.ops.object.modifier_apply(modifier="Skin")
        bpy.ops.object.modifier_apply(modifier="Subdivision")

    bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16, radius=1.0, location=(0, -0.02, 1.725))
    head = bpy.context.active_object
    head.name = "UnknownHead"
    head.scale = (0.082, 0.096, 0.115)
    # A jaw gives the profile a chin and the front view a narrower, longer lower face.
    bpy.ops.mesh.primitive_uv_sphere_add(segments=24, ring_count=12, radius=1.0, location=(0, -0.06, 1.655))
    jaw = bpy.context.active_object
    jaw.scale = (0.05, 0.05, 0.048)
    activate(head)
    jaw.select_set(True)
    with bpy.context.temp_override(active_object=head, selected_editable_objects=[head, jaw]):
        bpy.ops.object.join()
    return body, head


def build_rig():
    armature = bpy.data.armatures.new("UnknownRig")
    rig = bpy.data.objects.new("UnknownRig", armature)
    bpy.context.collection.objects.link(rig)
    activate(rig)
    bpy.ops.object.mode_set(mode="EDIT")
    for name, (head, tail, _) in BONES.items():
        bone = armature.edit_bones.new(name)
        bone.head, bone.tail = Vector(head), Vector(tail)
        bone.roll = 0.0
    for name, (_, _, parent) in BONES.items():
        if parent:
            armature.edit_bones[name].parent = armature.edit_bones[parent]
    bpy.ops.object.mode_set(mode="OBJECT")
    for bone in rig.pose.bones:
        bone.rotation_mode = "XYZ"
    return rig


def bind(body, head, rig) -> None:
    for obj in bpy.context.view_layer.objects:
        obj.select_set(False)
    body.select_set(True)
    rig.select_set(True)
    bpy.context.view_layer.objects.active = rig
    bpy.ops.object.parent_set(type="ARMATURE_AUTO")
    world = head.matrix_world.copy()
    head.parent = rig
    head.parent_type = "BONE"
    head.parent_bone = "head"
    head.matrix_world = world


class Poser:
    """Sets bone rotations in 'anatomical' terms, whatever each bone's local axes are.
    swing(bone, deg): positive moves the bone's tail forward (towards -Y) in the side plane.
    tilt(bone, deg): positive moves the tail towards the character's left (+X).
    twist(bone, deg): rotation about the bone's own length."""

    def __init__(self, rig):
        self.rig = rig
        self.signs: dict[tuple[str, int], float] = {}
        for bone in rig.pose.bones:
            for axis in (0, 2):
                self.signs[(bone.name, axis)] = self._probe(bone, axis)

    def _tail(self, bone) -> Vector:
        bpy.context.view_layer.update()
        return self.rig.matrix_world @ bone.tail

    def _probe(self, bone, axis: int) -> float:
        rest = self._tail(bone)
        bone.rotation_euler[axis] = 0.3
        moved = self._tail(bone) - rest
        bone.rotation_euler[axis] = 0.0
        bpy.context.view_layer.update()
        if axis == 0:  # swing: forward is -Y; for a bone pointing forward already, use -Z (down) as "forward"
            primary = -moved.y if abs(moved.y) >= abs(moved.z) else -moved.z
        else:  # tilt: towards +X
            primary = moved.x if abs(moved.x) >= 1e-6 else -moved.y
        return 1.0 if primary >= 0 else -1.0

    def pose(self, name: str, swing: float = 0.0, tilt: float = 0.0, twist: float = 0.0) -> None:
        bone = self.rig.pose.bones[name]
        bone.rotation_euler = Euler((
            math.radians(swing) * self.signs[(name, 0)],
            math.radians(twist),
            math.radians(tilt) * self.signs[(name, 2)],
        ))

    def lift(self, name: str, up: float) -> None:
        """Moves a bone along world Z (used for the hips' bob); bones here point up, so local Y is world Z."""
        self.rig.pose.bones[name].location = (0.0, up, 0.0)

    def key(self, frame: int) -> None:
        for bone in self.rig.pose.bones:
            bone.keyframe_insert("rotation_euler", frame=frame)
            bone.keyframe_insert("location", frame=frame)

    def reset(self) -> None:
        for bone in self.rig.pose.bones:
            bone.rotation_euler = (0, 0, 0)
            bone.location = (0, 0, 0)


ARMS_IN_WALK = 4.0  # the rest pose holds the arms slightly out; walking tucks them in a little


def base_pose(p: Poser) -> None:
    p.reset()
    for s in (".L", ".R"):
        p.pose("forearm" + s, swing=6)


def make_action(rig, name: str):
    action = bpy.data.actions.new(name)
    rig.animation_data_create()
    rig.animation_data.action = action
    return action


def walk(p: Poser) -> None:
    """A 24-frame (one second) walk cycle: contact, down, passing, up for each leg."""
    keys = {
        # frame: (thigh_R, shin_R, foot_R, thigh_L, shin_L, foot_L, hips_up)
        0: (24, 4, -12, -20, 12, 18, -0.005),
        3: (16, 22, 0, -12, 40, 14, -0.025),
        6: (2, 6, 0, 8, 62, 8, 0.0),
        9: (-14, 4, 18, 24, 32, -8, 0.015),
    }
    for frame, (tr, sr, fr, tl, sl, fl, up) in keys.items():
        for offset, mirror in ((0, False), (12, True)):
            base_pose(p)
            t_r, s_r, f_r, t_l, s_l, f_l = (tl, sl, fl, tr, sr, fr) if mirror else (tr, sr, fr, tl, sl, fl)
            p.pose("thigh.R", swing=t_r)
            p.pose("shin.R", swing=-s_r)
            p.pose("foot.R", swing=-f_r)
            p.pose("thigh.L", swing=t_l)
            p.pose("shin.L", swing=-s_l)
            p.pose("foot.L", swing=-f_l)
            # Arms swing against the legs; the chest counter-rotates a little.
            arm = (t_l - t_r) * 0.4
            p.pose("upper_arm.R", swing=arm, tilt=ARMS_IN_WALK)
            p.pose("upper_arm.L", swing=-arm, tilt=-ARMS_IN_WALK)
            p.pose("forearm.R", swing=16 + max(0.0, arm) * 0.9)
            p.pose("forearm.L", swing=16 + max(0.0, -arm) * 0.9)
            p.pose("spine", swing=4)
            p.pose("chest", twist=(t_r - t_l) * 0.12)
            p.pose("head", swing=-2)
            p.lift("hips", up)
            p.key(frame + offset)
    base_pose(p)
    # Close the loop: frame 24 equals frame 0.
    _copy_frame(p, 0, CYCLE)


def _copy_frame(p: Poser, source: int, target: int) -> None:
    bpy.context.scene.frame_set(source)
    for bone in p.rig.pose.bones:
        rot, loc = bone.rotation_euler.copy(), bone.location.copy()
        bone.rotation_euler, bone.location = rot, loc
    p.key(target)


def idle(p: Poser) -> None:
    """A two-second breathing loop with a slight sway."""
    for frame, (breath, sway) in {0: (0, 0), 12: (1, 0.5), 24: (0, 1), 36: (1, 0.5), 48: (0, 0)}.items():
        base_pose(p)
        p.pose("chest", swing=-1.5 * breath)
        p.pose("spine", swing=1.0 + 0.5 * breath, tilt=0.8 * (sway - 0.5))
        p.pose("head", swing=-1.0 + 0.6 * breath)
        p.pose("upper_arm.L", tilt=1.5 * breath)
        p.pose("upper_arm.R", tilt=-1.5 * breath)
        p.lift("hips", 0.004 * breath)
        p.key(frame)


def look_around(p: Poser) -> None:
    """Three seconds: looks to his left, then right, then back."""
    for frame, turn in {0: 0, 12: 35, 24: 35, 40: -35, 56: -35, 72: 0}.items():
        base_pose(p)
        p.pose("head", twist=turn * 0.7, swing=-1)
        p.pose("neck", twist=turn * 0.3)
        p.pose("chest", twist=turn * 0.15)
        p.key(frame)


ANIMATIONS = {
    "walk": (walk, CYCLE, True),
    "idle": (idle, 48, True),
    "look_around": (look_around, 72, False),
}
# Moments the game reacts to, in 24 fps frames: footsteps on each heel strike,
# the instant a hand closes on something.
EVENTS = {
    "walk": {0: "step", 12: "step"},
}
DIRECTIONS = {"d": 0.0, "r": 90.0, "u": 180.0}


def setup_camera():
    camera_data = bpy.data.cameras.new("SpriteCamera")
    camera_data.type = "ORTHO"
    camera_data.ortho_scale = ORTHO_SCALE
    camera = bpy.data.objects.new("SpriteCamera", camera_data)
    bpy.context.collection.objects.link(camera)
    center = HEIGHT / 2
    distance = 10.0
    tilt = math.radians(TILT_DEG)
    camera.location = (0.0, -distance * math.cos(tilt), center + distance * math.sin(tilt))
    camera.rotation_euler = (math.radians(90.0 - TILT_DEG), 0.0, 0.0)
    bpy.context.scene.camera = camera
    return camera


def setup_render() -> None:
    scene = bpy.context.scene
    scene.render.engine = "BLENDER_WORKBENCH"
    scene.display.shading.light = "FLAT"
    scene.display.shading.color_type = "SINGLE"
    scene.display.shading.single_color = (0.0, 0.0, 0.0)
    scene.display.render_aa = "16"
    scene.render.film_transparent = True
    scene.render.resolution_x, scene.render.resolution_y = FRAME
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGBA"
    scene.render.fps = 24
    scene.view_settings.view_transform = "Standard"


def pixel(scene, camera, world: Vector) -> list[float]:
    ndc = world_to_camera_view(scene, camera, world)
    return [round(ndc.x * FRAME[0], 2), round((1.0 - ndc.y) * FRAME[1], 2)]


def anchors(scene, camera, rig, head) -> dict:
    bones = rig.pose.bones
    world = rig.matrix_world
    head_center = head.matrix_world.translation.copy()
    basis = head.matrix_world.to_3x3()
    forward = (basis @ Vector((0.0, -1.0, 0.0))).normalized()
    left = (basis @ Vector((1.0, 0.0, 0.0))).normalized()
    up = (basis @ Vector((0.0, 0.0, 1.0))).normalized()
    to_camera = (camera.matrix_world.translation - head_center).normalized()
    eyes = {}
    for name, side in (("eye_l", 1.0), ("eye_r", -1.0)):
        offset = forward * 0.088 + left * (0.032 * side) + up * 0.006
        eyes[name] = (head_center + offset, offset.normalized().dot(to_camera) > 0.1)
    body_back = -(world.to_3x3() @ Vector((0.0, -1.0, 0.0))).normalized()
    chest_mid = world @ ((bones["chest"].head + bones["chest"].tail) / 2)
    return {
        "head": pixel(scene, camera, head_center),
        "eye_l": pixel(scene, camera, eyes["eye_l"][0]),
        "eye_r": pixel(scene, camera, eyes["eye_r"][0]),
        "eyes_visible": [eyes["eye_l"][1], eyes["eye_r"][1]],
        "shoulder_l": pixel(scene, camera, world @ bones["upper_arm.L"].head),
        "shoulder_r": pixel(scene, camera, world @ bones["upper_arm.R"].head),
        "back": pixel(scene, camera, chest_mid + body_back * 0.1 + Vector((0.0, 0.0, 0.08))),
        "hand_l": pixel(scene, camera, world @ bones["hand.L"].tail),
        "hand_r": pixel(scene, camera, world @ bones["hand.R"].tail),
        "feet": pixel(scene, camera, world @ Vector((0.0, 0.0, 0.0))),
    }


def foot_speed_px(scene, camera, rig, fps_frames: int) -> float:
    """Ground speed implied by the walk: how far the planted foot slides back per second, in pixels."""
    bones = rig.pose.bones
    samples = []
    for frame in range(0, 7):
        scene.frame_set(frame)
        samples.append((rig.matrix_world @ bones["foot.R"].head).y)
    metres_per_frame = (samples[-1] - samples[0]) / 6.0
    return abs(metres_per_frame) * 24.0 * CHARACTER_PX / HEIGHT


def sample_times(length: int, loop: bool, fps: float) -> list[float]:
    """When to sample each output frame, in 24 fps frames. A loop of LENGTH frames
    lasts LENGTH/24 s and does not repeat its first pose; a one-shot ends on its last."""
    step = 24.0 / fps
    count = round(length / step) if loop else int(length / step + 1e-6) + 1
    return [index * step for index in range(count)]


def event_frames(anim: str, times: list[float], length: int, loop: bool) -> list[dict]:
    """EVENTS for `anim` moved onto the output frame sampled nearest to each one."""
    events = []
    for time, name in sorted(EVENTS.get(anim, {}).items()):
        index = min(range(len(times)), key=lambda i: abs(times[i] - time))
        if loop and abs(length - time) < abs(times[index] - time):
            index = 0  # nearer to the loop's restart than to any sampled frame
        events.append({"frame": index, "name": name})
    return events


def render(rig, head, camera, out: Path, anims: list[str], dirs: list[str], fps: float) -> dict:
    scene = bpy.context.scene
    poser = Poser(rig)
    meta = {"frame_size": list(FRAME), "character_px": CHARACTER_PX, "fps": fps, "animations": {}}
    for anim in anims:
        build, length, loop = ANIMATIONS[anim]
        make_action(rig, anim)
        build(poser)
        for direction in dirs:
            rig.rotation_euler = (0.0, 0.0, math.radians(DIRECTIONS[direction]))
            key = f"{anim}_{direction}"
            frames, anchor_list = [], []
            times = sample_times(length, loop, fps)
            for index, time in enumerate(times):
                scene.frame_set(int(time), subframe=time - int(time))
                path = out / key / f"{key}_{index:03d}.png"
                scene.render.filepath = str(path)
                bpy.ops.render.render(write_still=True)
                frames.append(path.name)
                anchor_list.append(anchors(scene, camera, rig, head))
            entry = {"fps": fps, "frames": frames, "loop": loop, "anchors": anchor_list, "events": event_frames(anim, times, length, loop)}
            if anim == "walk":
                rig.rotation_euler = (0.0, 0.0, 0.0)
                entry["ground_px_per_second"] = round(foot_speed_px(scene, camera, rig, length), 1)
                rig.rotation_euler = (0.0, 0.0, math.radians(DIRECTIONS[direction]))
            meta["animations"][key] = entry
    rig.rotation_euler = (0.0, 0.0, 0.0)
    (out / "anchors.json").write_text(json.dumps(meta, indent=1) + "\n")
    return meta


def main() -> None:
    argv = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else []
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", required=True)
    parser.add_argument("--anims", default="walk,idle,look_around")
    parser.add_argument("--dirs", default="r,u,d")
    parser.add_argument("--fps", type=float, default=12.0)
    parser.add_argument("--blend")
    args = parser.parse_args(argv)
    clear_scene()
    body, head = build_body()
    rig = build_rig()
    bind(body, head, rig)
    camera = setup_camera()
    setup_render()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    meta = render(rig, head, camera, out, args.anims.split(","), args.dirs.split(","), args.fps)
    if args.blend:
        Path(args.blend).parent.mkdir(parents=True, exist_ok=True)
        bpy.ops.wm.save_as_mainfile(filepath=args.blend)
    summary = {k: {"frames": len(v["frames"]), **({"ground_px_per_second": v["ground_px_per_second"]} if "ground_px_per_second" in v else {})} for k, v in meta["animations"].items()}
    print("UNKNOWN_RENDER", json.dumps(summary))


main()
