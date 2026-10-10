"""Builds the gravestone close-up's art and spec (plan 007).

Run from the repository root:
    uv run --project tools/art python art-source/work/closeups/tombstone/build.py

Input (accepted, art-source/style/): tombstone-closeup.png (IMG-0010 v1).
Outputs: content/closeups/tombstone/art/bg.png and
art-source/work/closeups/tombstone/closeup_spec.json for addons/past_tools/new_closeup.gd.
"""

import json
from pathlib import Path

from past_art import grade
from past_art.imageio import load, save

ROOT = Path(__file__).resolve().parents[4]
WORK = ROOT / "art-source/work/closeups/tombstone"
ART = ROOT / "content/closeups/tombstone/art"
RES = "res://content/closeups/tombstone/art"
SIZE = (1920, 1080)

# Screen pixels (1920x1080), traced on the graded image.
NAME = [[630, 488], [1350, 488], [1350, 604], [630, 604]]
INSCRIPTION = [[620, 628], [1350, 628], [1350, 752], [620, 752]]
DOVE = [[820, 160], [1130, 160], [1130, 400], [820, 400]]


def main() -> None:
    save(ART / "bg.png", grade.monochrome(grade.resize(load(ROOT / "art-source/style/tombstone-closeup.png"), SIZE)))
    spec = {
        "background": f"{RES}/bg.png",
        "hotspots": [
            {"id": "name", "name": "The name", "polygon": NAME},
            {"id": "inscription", "name": "The inscription", "polygon": INSCRIPTION},
            {"id": "dove", "name": "A carved dove", "polygon": DOVE},
        ],
    }
    (WORK / "closeup_spec.json").write_text(json.dumps(spec, indent=2) + "\n")
    print(str(WORK / "closeup_spec.json"))


if __name__ == "__main__":
    main()
