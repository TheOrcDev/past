"""Builds the cathedral nave's shipping art and room spec from the accepted images.

Run from the repository root:
    uv run --project tools/art python art-source/work/rooms/cathedral_nave/build.py

Inputs (accepted, art-source/style/): the now style key (IMG-0001 v1) and the
then edit (IMG-0005 v1). Outputs: content/rooms/cathedral_nave/art/*.png and
art-source/work/rooms/cathedral_nave/room_spec.json for addons/past_tools/new_room.gd.
"""

import json
import math
from pathlib import Path

from past_art import align, grade, masks
from past_art.imageio import load, save

ROOT = Path(__file__).resolve().parents[4]
WORK = ROOT / "art-source/work/rooms/cathedral_nave"
ART = ROOT / "content/rooms/cathedral_nave/art"
RES = "res://content/rooms/cathedral_nave/art"
SIZE = (1920, 1080)

# All coordinates are room pixels (1920x1080), traced on the graded now image.
WALK = [[560, 908], [1590, 908], [1700, 945], [1770, 1000], [1760, 1075], [330, 1075], [300, 1015], [420, 950]]
OCCLUDERS = {
    "rubble_left": [[0, 945], [110, 950], [200, 975], [270, 1005], [320, 1045], [345, 1080], [0, 1080]],
    "rubble_right": [[1920, 960], [1840, 975], [1780, 1010], [1745, 1050], [1730, 1080], [1920, 1080]],
}
STATUE = [[100, 690], [290, 690], [290, 540], [325, 345], [290, 250], [240, 225], [200, 250], [165, 300], [150, 520], [110, 540]]
ALTAR = [[1320, 800], [1610, 800], [1610, 640], [1540, 500], [1470, 480], [1400, 500], [1330, 640]]
ROSE_WINDOW = [[round(1465 + 125 * math.cos(a * math.pi / 4)), round(255 + 125 * math.sin(a * math.pi / 4))] for a in range(8)]
# The breach over the rubble on the left, back to the cemetery (plan 007).
EXIT_WEST = [[0, 700], [240, 700], [330, 900], [345, 1080], [0, 1080]]


def build_backgrounds() -> dict:
    now_key = load(ROOT / "art-source/style/cathedral-nave-now-style-key.png")
    then_key = load(ROOT / "art-source/style/cathedral-nave-then.png")
    registration = align.register(now_key, then_key)
    then_aligned = align.warp(then_key, registration, (now_key.shape[1], now_key.shape[0]))
    now = grade.monochrome(grade.resize(now_key, SIZE))
    then = grade.resize(then_aligned, SIZE)
    save(ART / "bg_now.png", now)
    save(ART / "bg_then.png", then)
    walk_mask = masks.polygon_mask(SIZE, WALK)
    return {
        "then_alignment_p90_px": round(registration.residual_p90_px, 2),
        "walk_area_luminance_now": grade.region_luminance(now, walk_mask),
        "now": now,
        "then": then,
    }


def build_occluders(now, then) -> list[dict]:
    specs = []
    for name, polygon in OCCLUDERS.items():
        for era, image in (("now", now), ("then", then)):
            rgba, rect = masks.cut(image, masks.polygon_mask(SIZE, polygon, feather_px=1.5))
            file = f"occ_{name}_{era}.png"
            save(ART / file, rgba)
            specs.append({
                "name": f"{name.title().replace('_', '')}{era.title()}",
                "era": era,
                "texture": f"{RES}/{file}",
                "rect": list(rect),
                "baseline": 1080,
            })
    return specs


# Plan 008: the aisle arch to the cloister, and the great doors (right) to the city.
ARCH = [[985, 765], [985, 420], [1030, 378], [1082, 420], [1082, 765]]
DOORS = [[1780, 1000], [1780, 780], [1920, 760], [1920, 1078]]


def effects() -> list[dict]:
    depth = f"{RES}/depth_now.png"
    return [
        {"type": "FogLayer", "name": "FogFar", "era": "now", "properties": {
            "fog_color": [0.85, 0.86, 0.88, 1.0], "density": 0.32, "velocity": [0.006, 0.0], "noise_scale": [1.4, 0.8],
            "band_top": 0.42, "band_bottom": 0.9, "depth_texture": depth, "near_cutoff": 0.45, "noise_seed": 3}},
        {"type": "FogLayer", "name": "FogMid", "era": "now", "properties": {
            "fog_color": [0.8, 0.81, 0.84, 1.0], "density": 0.22, "velocity": [-0.01, 0.0], "noise_scale": [2.2, 1.1],
            "band_top": 0.62, "band_bottom": 0.92, "depth_texture": depth, "near_cutoff": 0.55, "noise_seed": 5}},
        {"type": "LightShafts", "name": "Shafts", "era": "now", "properties": {
            "origin": [1465, 255], "aim": 210.0, "spread": 38.0, "beams": 6.0, "intensity": 0.1, "reach": 0.95,
            "shaft_color": [0.95, 0.96, 1.0, 1.0], "flicker": 0.4}},
        {"type": "DustMotes", "name": "Ash", "era": "now", "properties": {
            "area": [300, 200, 1400, 700], "mote_color": [0.85, 0.85, 0.88, 0.35], "mote_count": 50, "drift": [4, 6], "mote_size": 2.5}},
        {"type": "FogLayer", "name": "GroundMist", "era": "now", "layer": "foreground", "properties": {
            "fog_color": [0.86, 0.87, 0.9, 1.0], "density": 0.18, "velocity": [0.012, 0.0], "noise_scale": [2.6, 1.6],
            "band_top": 0.86, "band_bottom": 1.02, "band_softness": 0.08, "noise_seed": 9}},
        {"type": "LightShafts", "name": "GoldenShafts", "era": "then", "properties": {
            "origin": [1465, 255], "aim": 210.0, "spread": 44.0, "beams": 7.0, "intensity": 0.16, "reach": 1.0,
            "shaft_color": [1.0, 0.85, 0.55, 1.0], "flicker": 0.25}},
        {"type": "FogLayer", "name": "WarmHaze", "era": "then", "properties": {
            "fog_color": [1.0, 0.9, 0.75, 1.0], "density": 0.1, "velocity": [0.004, 0.0], "noise_scale": [1.2, 0.7],
            "band_top": 0.3, "band_bottom": 0.9, "noise_seed": 13}},
        {"type": "DustMotes", "name": "GoldenDust", "era": "then", "properties": {
            "area": [300, 150, 1500, 750], "mote_color": [1.0, 0.86, 0.55, 0.55], "mote_count": 70, "drift": [3, -4], "mote_size": 2.5}},
    ]


def main() -> None:
    backgrounds = build_backgrounds()
    occluders = build_occluders(backgrounds["now"], backgrounds["then"])
    spec = {
        "display_name": "Cathedral nave",
        "layers": {
            "now": [{"name": "Background", "texture": f"{RES}/bg_now.png"}],
            "then": [{"name": "Background", "texture": f"{RES}/bg_then.png"}],
        },
        "walk": {"now": WALK, "then": WALK},
        "scale_zones": {"far_y": 908, "far_scale": 0.62, "near_y": 1075, "near_scale": 1.0},
        "markers": {"default": [900, 1010], "from_cemetery": [430, 1010], "from_cloister": [1030, 935], "from_parvis": [1690, 1015]},
        "hotspots": [
            {"id": "statue", "name": "Statue of a saint", "polygon": STATUE, "walk_to": [480, 960], "default_verb": "use"},
            {"id": "altar", "name": "Altar", "polygon": ALTAR, "walk_to": [1460, 930]},
            {"id": "rose_window", "name": "Rose window", "polygon": ROSE_WINDOW, "walk_to": [1320, 935]},
            {"id": "exit_west", "name": "To the cemetery", "polygon": EXIT_WEST, "walk_to": [350, 1030],
             "exit": {"room": "cemetery_grave", "entry": "from_cathedral", "direction": "left"}},
            {"id": "arch", "name": "Arch to the cloister", "polygon": ARCH, "walk_to": [1030, 925],
             "exit": {"room": "cathedral_cloister", "entry": "from_nave", "direction": "up"}},
            {"id": "doors", "name": "The great doors", "polygon": DOORS, "walk_to": [1720, 1015], "default_verb": "use", "pick_priority": 1},
        ],
        "occluders": occluders,
        "effects": effects(),
    }
    (WORK / "room_spec.json").write_text(json.dumps(spec, indent=2) + "\n")
    print(json.dumps({
        "then_alignment_p90_px": backgrounds["then_alignment_p90_px"],
        "walk_area_luminance_now": backgrounds["walk_area_luminance_now"],
        "occluders": [o["name"] for o in occluders],
        "spec": str(WORK / "room_spec.json"),
    }, indent=2))


if __name__ == "__main__":
    main()
