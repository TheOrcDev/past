"""Side-by-side clip of Unknown's walk at 12 and 15 fps (plan 002, slice 4).

Both lanes step the way the game does (Actor.step_with_frames): the figure moves
one frame's worth of ground each time a new frame shows, so only the cadence
differs. Run from the repository root:

  uv run --project tools/art python art-source/work/characters/unknown/compare_walk.py
"""

import json
import subprocess
from pathlib import Path

import cv2
import numpy as np

HERE = Path(__file__).parent
ROOT = HERE.parents[3]
OUT = ROOT / "docs/qa/002/unknown-walk-12-vs-15fps.mp4"
BACKGROUND = ROOT / "content/rooms/cathedral_nave/art/bg_now.png"
LANES = [("12 fps", HERE / "renders"), ("15 fps", HERE / "renders-walk15")]
SCALE = 0.8
FEET_Y = 495  # in each 540-pixel lane
START_X = 220
SECONDS = 5.5
VIDEO_FPS = 60


def load_walk(folder: Path) -> tuple[list[np.ndarray], float, float, np.ndarray]:
    meta = json.loads((folder / "anchors.json").read_text())
    entry = meta["animations"]["walk_r"]
    frames = []
    for name in entry["frames"]:
        image = cv2.imread(str(folder / "walk_r" / name), cv2.IMREAD_UNCHANGED)
        alpha = image[:, :, 3].astype(np.float32) / 255.0
        frames.append(cv2.resize(alpha, None, fx=SCALE, fy=SCALE, interpolation=cv2.INTER_AREA))
    feet = np.array(entry["anchors"][0]["feet"]) * SCALE
    return frames, float(entry.get("fps", meta["fps"])), float(entry["ground_px_per_second"]), feet


def main() -> None:
    background = cv2.imread(str(BACKGROUND), cv2.IMREAD_GRAYSCALE)
    lane_bg = background[540:1080].astype(np.float32)
    lanes = [(label, *load_walk(folder)) for label, folder in LANES]
    OUT.parent.mkdir(parents=True, exist_ok=True)
    ffmpeg = subprocess.Popen(
        ["ffmpeg", "-y", "-loglevel", "error", "-f", "rawvideo", "-pix_fmt", "gray", "-s", "1920x1080",
         "-r", str(VIDEO_FPS), "-i", "-", "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "20", str(OUT)],
        stdin=subprocess.PIPE,
    )
    for tick in range(int(SECONDS * VIDEO_FPS)):
        t = tick / VIDEO_FPS
        canvas = np.zeros((1080, 1920), np.float32)
        for index, (label, frames, fps, ground, feet) in enumerate(lanes):
            lane = lane_bg.copy()
            shown = int(t * fps)
            alpha = frames[shown % len(frames)]
            x = int(round(START_X + shown * ground * SCALE / fps - feet[0]))
            y = int(round(FEET_Y - feet[1]))
            h, w = alpha.shape
            visible = alpha[max(0, -y) : 540 - y, max(0, -x) : 1920 - x]
            lane[max(0, y) : max(0, y) + visible.shape[0], max(0, x) : max(0, x) + visible.shape[1]] *= 1.0 - visible
            cv2.putText(lane, label, (40, 70), cv2.FONT_HERSHEY_SIMPLEX, 1.6, 255, 3, cv2.LINE_AA)
            canvas[index * 540 : (index + 1) * 540] = lane
        canvas[538:542] = 0
        ffmpeg.stdin.write(np.clip(canvas, 0, 255).astype(np.uint8).tobytes())
    ffmpeg.stdin.close()
    ffmpeg.wait()
    print(f"wrote {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
