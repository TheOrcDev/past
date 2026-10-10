"""Packs rendered character frames (tools/blender/unknown.py) into single-channel
alpha-mask sprite sheets plus a JSON manifest (docs/technical-plan.md §8:
one byte per pixel; the game draws the silhouette black and adds the rim).

Each frame is trimmed to its silhouette plus a transparent border, so shaders
can sample a few texels past the edge, and the frames are shelf-packed into one
sheet per animation. The manifest gives each frame's region in its sheet and
the region's offset in the full frame, which Godot's AtlasTexture takes as
region and margin.
"""

import json
from pathlib import Path

import numpy as np

from .imageio import load, save

MAX_SHEET = 4096
BORDER = 6  # transparent texels kept around each trimmed silhouette
SPACING = 2  # texels between packed regions


def alpha_of(image: np.ndarray) -> np.ndarray:
    if image.ndim == 3 and image.shape[2] == 4:
        return image[:, :, 3]
    return np.full(image.shape[:2], 255, np.uint8)


def trim_box(alpha: np.ndarray, border: int = BORDER) -> tuple[int, int, int, int]:
    """x, y, width, height of the silhouette's bounding box grown by BORDER, within the frame."""
    ys, xs = np.nonzero(alpha)
    if len(xs) == 0:
        return 0, 0, 1, 1
    h, w = alpha.shape
    x0, x1 = max(0, int(xs.min()) - border), min(w, int(xs.max()) + 1 + border)
    y0, y1 = max(0, int(ys.min()) - border), min(h, int(ys.max()) + 1 + border)
    return x0, y0, x1 - x0, y1 - y0


def shelf_pack(sizes: list[tuple[int, int]], width: int) -> tuple[list[tuple[int, int]], int, int]:
    """Places boxes left to right in rows no wider than WIDTH. Returns their
    positions and the used width and height."""
    positions: list[tuple[int, int]] = []
    x = y = row_h = used_w = 0
    for w, h in sizes:
        if x > 0 and x + w > width:
            x, y, row_h = 0, y + row_h + SPACING, 0
        positions.append((x, y))
        used_w = max(used_w, x + w)
        row_h = max(row_h, h)
        x += w + SPACING
    return positions, used_w, y + row_h


def best_layout(sizes: list[tuple[int, int]]) -> tuple[list[tuple[int, int]], int, int]:
    """The shelf width, in steps of 16, that gives the smallest sheet within MAX_SHEET."""
    best = None
    for width in range(max(w for w, _ in sizes), MAX_SHEET + 1, 16):
        layout = shelf_pack(sizes, width)
        if layout[2] <= MAX_SHEET and (best is None or layout[1] * layout[2] < best[1] * best[2]):
            best = layout
    if best is None:
        raise ValueError(f"{len(sizes)} frames do not fit one {MAX_SHEET}px sheet")
    return best


def pack(renders: list[Path], out_dir: Path, manifest_path: Path, res_prefix: str, name: str) -> dict:
    """Packs every animation in RENDERS; a later folder replaces an earlier
    folder's animation of the same name (for example a walk at another rate)."""
    sources: dict[str, tuple[Path, dict]] = {}
    frame_size = character_px = None
    for folder in renders:
        meta = json.loads((folder / "anchors.json").read_text())
        if frame_size is not None and (meta["frame_size"] != frame_size or meta["character_px"] != character_px):
            raise ValueError(f"{folder}: frame size or character height differs from {renders[0]}")
        frame_size, character_px = meta["frame_size"], meta["character_px"]
        for key, entry in meta["animations"].items():
            sources[key] = (folder, {"fps": meta["fps"], **entry})
    manifest: dict = {"frame_size": frame_size, "character_px": character_px, "animations": {}}
    for key, (folder, entry) in sources.items():
        alphas = [alpha_of(load(folder / key / frame)) for frame in entry["frames"]]
        boxes = [trim_box(alpha) for alpha in alphas]
        positions, sheet_w, sheet_h = best_layout([(w, h) for _, _, w, h in boxes])
        sheet = np.zeros((sheet_h, sheet_w), dtype=np.uint8)
        frames = []
        for alpha, (x, y, w, h), (px, py) in zip(alphas, boxes, positions):
            sheet[py : py + h, px : px + w] = alpha[y : y + h, x : x + w]
            frames.append({"region": [px, py, w, h], "offset": [x, y]})
        file = f"{name}_{key}.png"
        save(out_dir / file, sheet)
        record = {
            "sheet": f"{res_prefix}/{file}",
            "fps": entry["fps"],
            "loop": entry["loop"],
            "frames": frames,
            "anchors": entry["anchors"],
        }
        if "ground_px_per_second" in entry:
            record["ground_px_per_second"] = entry["ground_px_per_second"]
        manifest["animations"][key] = record
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, indent=1) + "\n")
    return manifest
