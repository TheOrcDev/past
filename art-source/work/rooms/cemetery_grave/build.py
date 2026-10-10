"""Builds the grave room's shipping art and room spec (plan 007).

Run from the repository root:
    uv run --project tools/art python art-source/work/rooms/cemetery_grave/build.py

Input (accepted, art-source/style/): cemetery-grave-now.png (IMG-0009 v1).
Outputs: content/rooms/cemetery_grave/art/{bg_now,depth_now}.png and
art-source/work/rooms/cemetery_grave/room_spec.json for addons/past_tools/new_room.gd.
"""

import json
from pathlib import Path

from past_art import depth, grade, masks
from past_art.imageio import load, save

ROOT = Path(__file__).resolve().parents[4]
WORK = ROOT / "art-source/work/rooms/cemetery_grave"
ART = ROOT / "content/rooms/cemetery_grave/art"
RES = "res://content/rooms/cemetery_grave/art"
SIZE = (1920, 1080)

# Room pixels (1920x1080), traced on the graded image.
WALK = [[0, 840], [400, 815], [650, 800], [1150, 810], [1500, 840], [1920, 845], [1920, 1062], [0, 1062]]
GRAVESTONE = [[605, 650], [605, 330], [640, 292], [700, 272], [760, 280], [800, 302], [835, 360], [840, 650]]
GRAVE = [[600, 652], [1150, 662], [1180, 780], [980, 806], [620, 798]]
ANGEL = [[350, 500], [350, 262], [392, 206], [440, 216], [462, 300], [462, 500]]
MAUSOLEUM = [[110, 580], [110, 262], [200, 172], [300, 200], [395, 300], [395, 580]]
CITY = [[1030, 380], [1030, 200], [1150, 60], [1300, 40], [1500, 90], [1700, 160], [1800, 380]]
EXIT_EAST = [[1820, 815], [1920, 815], [1920, 1062], [1820, 1062]]


def build_background() -> dict:
    key = load(ROOT / "art-source/style/cemetery-grave-now.png")
    now = grade.monochrome(grade.resize(key, SIZE))
    save(ART / "bg_now.png", now)
    save(ART / "depth_now.png", depth.estimate(grade.resize(key, (SIZE[0] // 2, SIZE[1] // 2))[:, :, :3]))
    return {"walk_area_luminance_now": grade.region_luminance(now, masks.polygon_mask(SIZE, WALK))}


def effects() -> list[dict]:
    depth_tex = f"{RES}/depth_now.png"
    return [
        {"type": "FogLayer", "name": "FogFar", "era": "now", "properties": {
            "fog_color": [0.85, 0.86, 0.89, 1.0], "density": 0.3, "velocity": [0.005, 0.0], "noise_scale": [1.4, 0.8],
            "band_top": 0.3, "band_bottom": 0.75, "depth_texture": depth_tex, "near_cutoff": 0.4, "noise_seed": 21}},
        {"type": "FogLayer", "name": "FogLow", "era": "now", "properties": {
            "fog_color": [0.8, 0.82, 0.86, 1.0], "density": 0.24, "velocity": [-0.008, 0.0], "noise_scale": [2.2, 1.1],
            "band_top": 0.5, "band_bottom": 0.82, "depth_texture": depth_tex, "near_cutoff": 0.55, "noise_seed": 23}},
        {"type": "LightShafts", "name": "Moonlight", "era": "now", "properties": {
            "origin": [1480, 120], "aim": 225.0, "spread": 30.0, "beams": 5.0, "intensity": 0.07, "reach": 0.9,
            "shaft_color": [0.9, 0.93, 1.0, 1.0], "flicker": 0.3}},
        {"type": "FogLayer", "name": "GroundMist", "era": "now", "layer": "foreground", "properties": {
            "fog_color": [0.86, 0.87, 0.9, 1.0], "density": 0.16, "velocity": [0.01, 0.0], "noise_scale": [2.6, 1.6],
            "band_top": 0.84, "band_bottom": 1.02, "band_softness": 0.08, "noise_seed": 27}},
    ]


def main() -> None:
    report = build_background()
    spec = {
        "display_name": "Cemetery",
        "layers": {"now": [{"name": "Background", "texture": f"{RES}/bg_now.png"}]},
        "walk": {"now": WALK},
        "scale_zones": {"far_y": 800, "far_scale": 0.82, "near_y": 1060, "near_scale": 1.0},
        "markers": {"default": [900, 905], "from_cathedral": [1760, 920]},
        "hotspots": [
            {"id": "gravestone", "name": "Gravestone", "polygon": GRAVESTONE, "walk_to": [730, 870], "pick_priority": 1},
            {"id": "grave", "name": "Grave", "polygon": GRAVE, "walk_to": [880, 880]},
            {"id": "angel", "name": "Weeping angel", "polygon": ANGEL, "walk_to": [430, 875], "pick_priority": 1},
            {"id": "mausoleum", "name": "Mausoleum", "polygon": MAUSOLEUM, "walk_to": [260, 880]},
            {"id": "city", "name": "The city", "polygon": CITY, "walk_to": [1400, 880]},
            {"id": "exit_east", "name": "To the cathedral", "polygon": EXIT_EAST, "walk_to": [1880, 930],
             "exit": {"room": "cathedral_nave", "entry": "from_cemetery", "direction": "right"}},
        ],
        "occluders": [],
        "effects": effects(),
    }
    (WORK / "room_spec.json").write_text(json.dumps(spec, indent=2) + "\n")
    print(json.dumps({**report, "spec": str(WORK / "room_spec.json")}, indent=2))


if __name__ == "__main__":
    main()
