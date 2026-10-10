"""Builds the cemetery reveal's zoom-stack rings and spec from the accepted images.

Run from the repository root:
    uv run --project tools/art python art-source/work/reveal/cemetery/build.py

Each ring is a 2x detail repaint of the centre of the ring outside it
(rings.json). Inner rings are registered onto their outer ring's region and
level-matched to it (past_art.rings), then every ring goes monochrome (the
present). The rings ship as one-byte greyscale; the engine feathers the inner
rings' edges in a shader. Outputs content/cutscenes/cemetery_reveal/art/ring*.png
and art-source/work/reveal/cemetery/reveal_spec.json for new_reveal.gd.
"""

import json
from pathlib import Path

from past_art import grade, rings
from past_art.imageio import load, save

ROOT = Path(__file__).resolve().parents[4]
WORK = ROOT / "art-source/work/reveal/cemetery"
ART = ROOT / "content/cutscenes/cemetery_reveal/art"
RES = "res://content/cutscenes/cemetery_reveal/art"
OUTER = ROOT / "art-source/raw/IMG-0006/IMG-0006-v1.png"
INNER = [ROOT / "art-source/raw/IMG-0007/IMG-0007-v1.png", ROOT / "art-source/raw/IMG-0008/IMG-0008-v2.png"]
FEATHER = 0.08  # of the shorter side, as past_art.rings.prepare_ring

# Ring 0 pixels. Unknown stands on the path below the zoom point, facing the city.
UNKNOWN_FEET = [906, 800]
UNKNOWN_HEIGHT = 260
# The opening frame holds all of Unknown; the last fills the 2.39:1 letterbox with ring 0.
START_ZOOM = 2.4
START_CENTER = [906, 670]


def main() -> None:
    spec = json.loads((WORK / "rings.json").read_text())
    crops = [spec["ring1"]["source_crop_in_ring0"], spec["ring2"]["source_crop_in_ring1"]]
    outer = load(OUTER)
    images = [outer]
    report = []
    for index, (inner_path, crop) in enumerate(zip(INNER, crops), start=1):
        prepared, registration = rings.prepare_ring(images[-1], load(inner_path), tuple(crop), FEATHER)
        images.append(prepared[:, :, :3])
        report.append({"ring": index, "residual_p90_px": round(registration.residual_p90_px, 2), "scale": round(registration.scale, 4)})
    placements = []
    position, scale = [0.0, 0.0], 1.0
    for index, image in enumerate(images):
        if index > 0:
            x, y, _, _ = crops[index - 1]
            position = [position[0] + x * scale, position[1] + y * scale]
            scale *= 0.5
        file = f"ring{index}.png"
        save(ART / file, grade.monochrome(image))
        placements.append({"texture": f"{RES}/{file}", "position": position, "scale": scale})
    h, w = outer.shape[:2]
    reveal = {
        "rings": placements,
        "world_size": [w, h],
        "feather": FEATHER,
        "zoom_point": spec["zoom_point_ring0"],
        "unknown": {"feet": UNKNOWN_FEET, "height": UNKNOWN_HEIGHT, "facing": "idle_r"},
        "start": {"zoom": START_ZOOM, "center": START_CENTER},
        "end": {"zoom": round(803 / h, 4), "center": [w / 2, h / 2]},
        "alignment": report,
    }
    (WORK / "reveal_spec.json").write_text(json.dumps(reveal, indent=2) + "\n")
    print(json.dumps({"alignment": report, "rings": placements}, indent=2))


if __name__ == "__main__":
    main()
