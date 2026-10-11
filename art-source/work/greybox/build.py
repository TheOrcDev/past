"""Builds the greybox puzzle chain's art and specs (plan 004 slice 11).

Three rooms drawn in code as flat value studies: the gatehouse, the chapel
(with its past, where the altar's carving still reads) and the courtyard beyond
the gate. Also the props that leave a room when taken, and the item icons.
Nothing here is generated or paid for; it is placeholder art for testing the
core, not the game's look.

Run from the repository root:
    uv run --project tools/art python art-source/work/greybox/build.py
Then import, and scaffold each room and the items (see plan 004's record).
"""

import json
from pathlib import Path

import cv2
import numpy as np

from past_art.imageio import save

ROOT = Path(__file__).resolve().parents[3]
WORK = ROOT / "art-source/work"
W, H = 1920, 1080
HORIZON = 760
WALK = [[0, 790], [1920, 790], [1920, 1062], [0, 1062]]
SCALE = {"far_y": 790, "far_scale": 0.72, "near_y": 1062, "near_scale": 1.0}
RNG = np.random.default_rng(11)

# The gatehouse, in room pixels.
GATE = (1500, 300, 1820, 900)
KEEPER = [[850, 860], [850, 760], [880, 760], [880, 450], [895, 380], [930, 352], [965, 380], [980, 450], [980, 760], [1010, 760], [1010, 860]]
RAG = (262, 430, 362, 580)
# The chapel.
ALTAR = (820, 560, 1100, 820)
FLASK = (1520, 420, 1590, 530)
WINDOW = (380, 170, 540, 520)
# The courtyard.
PATH = [[700, 790], [1180, 790], [1500, 1062], [420, 1062]]


def room(wall: tuple[float, float], floor: tuple[float, float]) -> np.ndarray:
    """A wall and a floor, darker towards the top."""
    img = np.zeros((H, W), np.float32)
    img[:HORIZON] = np.linspace(wall[0], wall[1], HORIZON)[:, None]
    img[HORIZON:] = np.linspace(floor[0], floor[1], H - HORIZON)[:, None]
    for x in range(-W, 2 * W, 160):  # floor boards running into the distance
        cv2.line(img, (W // 2 + (x - W // 2) // 3, HORIZON), (x, H), floor[0] * 0.85, 2, cv2.LINE_AA)
    return img


def stones(img: np.ndarray, top: int, bottom: int, shade: float) -> None:
    for i, y in enumerate(range(top, bottom, 70)):
        cv2.line(img, (0, y), (W, y), shade, 2, cv2.LINE_AA)
        for x in range(-140 + (i % 2) * 70, W, 140):
            cv2.line(img, (x, y), (x, min(y + 70, bottom)), shade, 2, cv2.LINE_AA)


def box(img: np.ndarray, rect: tuple[int, int, int, int], value: float) -> None:
    cv2.rectangle(img, rect[:2], rect[2:], value, -1, cv2.LINE_AA)


def poly(img: np.ndarray, points: list, value: float) -> None:
    cv2.fillPoly(img, [np.array(points, np.int32)], value, cv2.LINE_AA)


def doorway(img: np.ndarray, x0: int, x1: int) -> None:
    box(img, (x0, 560, x1, HORIZON + 120), 0.06)


def finish(img: np.ndarray, warm: bool = False) -> np.ndarray:
    """Grain, a vignette and BGR; `warm` tints it like the past."""
    img = cv2.GaussianBlur(img, (0, 0), 1.2) + RNG.normal(0.0, 0.012, img.shape).astype(np.float32)
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    img *= 1.0 - 0.35 * (((xx - W / 2) / (W / 2)) ** 2 + ((yy - H / 2) / (H / 1.2)) ** 2)
    img = np.clip(img, 0.0, 1.0)
    tint = (0.72, 0.9, 1.08) if warm else (1.0, 1.0, 1.0)
    return np.dstack([np.clip(img * t, 0.0, 1.0) for t in tint]).__mul__(255).astype(np.uint8)


def prop(draw, size: tuple[int, int]) -> np.ndarray:
    """A BGRA cut-out: `draw(value, alpha)` paints onto two float planes."""
    value = np.zeros((size[1], size[0]), np.float32)
    alpha = np.zeros_like(value)
    draw(value, alpha)
    alpha = cv2.GaussianBlur(alpha, (0, 0), 0.8)
    grey = (np.clip(value, 0, 1) * 255).astype(np.uint8)
    return np.dstack([grey, grey, grey, (np.clip(alpha, 0, 1) * 255).astype(np.uint8)])


def gate_room() -> dict:
    img = room((0.14, 0.24), (0.30, 0.44))
    stones(img, 40, HORIZON, 0.11)
    x0, y0, x1, y1 = GATE
    cv2.ellipse(img, ((x0 + x1) // 2, y0 + 80), ((x1 - x0) // 2, 110), 0, 180, 360, 0.04, -1, cv2.LINE_AA)
    box(img, (x0, y0 + 80, x1, y1), 0.04)
    box(img, (840, 760, 1020, 870), 0.38)  # the gatekeeper's plinth
    poly(img, [[880, 760], [880, 460], [980, 460], [980, 760]], 0.47)
    cv2.circle(img, (930, 400), 44, 0.5, -1, cv2.LINE_AA)
    poly(img, [[880, 470], [840, 640], [866, 650], [890, 520]], 0.44)  # an arm held out
    cv2.line(img, (300, 432), (300, 452), 0.08, 6, cv2.LINE_AA)  # the hook
    cv2.line(img, (300, 452), (318, 452), 0.08, 6, cv2.LINE_AA)
    doorway(img, 0, 95)

    def bars(value, alpha):
        for x in range(10, x1 - x0, 38):
            cv2.line(value, (x, 0), (x, y1 - y0 + 10), 0.1, 9)
            cv2.line(alpha, (x, 0), (x, y1 - y0 + 10), 1.0, 9)
        for y in (140, 380, 560):
            cv2.line(value, (0, y), (x1 - x0, y), 0.13, 12)
            cv2.line(alpha, (0, y), (x1 - x0, y), 1.0, 12)
        for _ in range(60):  # rust
            cx, cy = int(RNG.integers(0, x1 - x0)), int(RNG.integers(0, y1 - y0))
            cv2.circle(value, (cx, cy), int(RNG.integers(2, 6)), 0.3, -1)

    def rag(value, alpha):
        points = np.array([[38, 18], [62, 16], [74, 70], [88, 128], [60, 140], [36, 132], [14, 136], [26, 70]], np.int32)
        cv2.fillPoly(value, [points], 0.62, cv2.LINE_AA)
        cv2.fillPoly(alpha, [points], 1.0, cv2.LINE_AA)
        for x in (34, 50, 66):
            cv2.line(value, (x, 30), (x - 6, 130), 0.5, 2, cv2.LINE_AA)

    art = "content/rooms/greybox_gate/art"
    save(ROOT / art / "bg_now.png", finish(img))
    save(ROOT / art / "gate.png", prop(bars, (x1 - x0, y1 - y0 + 10)))
    save(ROOT / art / "rag.png", prop(rag, (RAG[2] - RAG[0], RAG[3] - RAG[1])))
    gate_poly = [[x0, y1], [x0, y0 + 80], [(x0 + x1) // 2, y0 - 30], [x1, y0 + 80], [x1, y1]]
    res = "res://" + art
    return {
        "display_name": "Gatehouse",
        "layers": {"now": [
            {"name": "Background", "texture": f"{res}/bg_now.png"},
            {"name": "Gate", "texture": f"{res}/gate.png", "position": [x0, y0]},
            {"name": "Rag", "texture": f"{res}/rag.png", "position": [RAG[0], RAG[1]]},
        ]},
        "walk": {"now": WALK},
        "scale_zones": SCALE,
        "markers": {"default": [700, 960], "from_chapel": [170, 980], "from_courtyard": [1640, 960]},
        "hotspots": [
            {"id": "gatekeeper", "name": "Gatekeeper", "polygon": KEEPER, "walk_to": [930, 905], "default_verb": "talk"},
            {"id": "gate", "name": "Rusted gate", "polygon": gate_poly, "walk_to": [1560, 935]},
            {"id": "rag", "name": "Rag", "polygon": [[RAG[0], RAG[1]], [RAG[2], RAG[1]], [RAG[2], RAG[3]], [RAG[0], RAG[3]]],
             "walk_to": [330, 930]},
            {"id": "exit_west", "name": "To the chapel", "polygon": [[0, 560], [95, 560], [95, 1062], [0, 1062]],
             "walk_to": [60, 980], "exit": {"room": "greybox_chapel", "entry": "from_gate", "direction": "left"}},
            {"id": "beyond", "name": "Through the gate", "polygon": gate_poly, "walk_to": [1660, 935],
             "exit": {"room": "greybox_courtyard", "entry": "from_gate", "direction": "right"}},
        ],
    }


def chapel(past: bool) -> np.ndarray:
    img = room((0.3, 0.42) if past else (0.18, 0.28), (0.4, 0.56) if past else (0.32, 0.46))
    stones(img, 40, HORIZON, 0.36 if past else 0.15)
    box(img, WINDOW, 0.9 if past else 0.62)
    cv2.line(img, ((WINDOW[0] + WINDOW[2]) // 2, WINDOW[1]), ((WINDOW[0] + WINDOW[2]) // 2, WINDOW[3]), 0.2, 6)
    cv2.line(img, (WINDOW[0], 340), (WINDOW[2], 340), 0.2, 6)
    x0, y0, x1, y1 = ALTAR
    box(img, (x0 - 20, y0 - 30, x1 + 20, y0), 0.6 if past else 0.48)
    box(img, (x0, y0, x1, y1), 0.55 if past else 0.42)
    if past:
        cv2.putText(img, "MERCY", (x0 + 34, y0 + 105), cv2.FONT_HERSHEY_TRIPLEX, 2.0, 0.22, 4, cv2.LINE_AA)
        for cx in (x0 + 30, x1 - 30):  # candles
            box(img, (cx - 8, y0 - 110, cx + 8, y0 - 30), 0.85)
            cv2.circle(img, (cx, y0 - 122), 9, 1.0, -1, cv2.LINE_AA)
    else:
        for _ in range(26):  # where the fire took the carving
            cx, cy = int(RNG.integers(x0 + 30, x1 - 30)), int(RNG.integers(y0 + 40, y0 + 120))
            cv2.circle(img, (cx, cy), int(RNG.integers(8, 22)), 0.12, -1, cv2.LINE_AA)
    box(img, (1400, 530, 1700, 546), 0.4 if not past else 0.5)  # the shelf
    doorway(img, 1825, 1920)
    return img


def chapel_room() -> dict:
    def flask(value, alpha):
        body = np.array([[12, 50], [58, 50], [64, 104], [6, 104]], np.int32)
        neck = np.array([[26, 16], [44, 16], [44, 52], [26, 52]], np.int32)
        for shape, shade in ((body, 0.55), (neck, 0.5)):
            cv2.fillPoly(value, [shape], shade, cv2.LINE_AA)
            cv2.fillPoly(alpha, [shape], 1.0, cv2.LINE_AA)
        cv2.rectangle(value, (24, 4), (46, 18), 0.3, -1)
        cv2.rectangle(alpha, (24, 4), (46, 18), 1.0, -1)
        cv2.line(value, (20, 60), (16, 98), 0.8, 3, cv2.LINE_AA)

    art = "content/rooms/greybox_chapel/art"
    save(ROOT / art / "bg_now.png", finish(chapel(False)))
    save(ROOT / art / "bg_then.png", finish(chapel(True), warm=True))
    save(ROOT / art / "flask.png", prop(flask, (FLASK[2] - FLASK[0], FLASK[3] - FLASK[1])))
    res = "res://" + art
    x0, y0, x1, y1 = ALTAR
    return {
        "display_name": "Chapel",
        "layers": {
            "now": [
                {"name": "Background", "texture": f"{res}/bg_now.png"},
                {"name": "Flask", "texture": f"{res}/flask.png", "position": [FLASK[0], FLASK[1]]},
            ],
            "then": [{"name": "Background", "texture": f"{res}/bg_then.png"}],
        },
        "walk": {"now": WALK, "then": WALK},
        "scale_zones": SCALE,
        "markers": {"default": [960, 960], "from_gate": [1750, 980]},
        "hotspots": [
            # Unknown stands beside the altar, so its carving stays in view.
            {"id": "altar", "name": "Altar", "polygon": [[x0 - 20, y1], [x0 - 20, y0 - 30], [x1 + 20, y0 - 30], [x1 + 20, y1]],
             "walk_to": [1210, 905]},
            # Only in the past (a playable memory): the carving, still whole.
            {"id": "carving", "name": "Carving", "era": "then", "pick_priority": 1,
             "polygon": [[x0, y0 + 30], [x1, y0 + 30], [x1, y0 + 130], [x0, y0 + 130]], "walk_to": [1210, 905]},
            {"id": "flask", "name": "Oil flask", "polygon": [[FLASK[0], FLASK[1]], [FLASK[2], FLASK[1]], [FLASK[2], FLASK[3]], [FLASK[0], FLASK[3]]],
             "walk_to": [1560, 920], "pick_priority": 1},
            {"id": "window", "name": "Window", "polygon": [[WINDOW[0], WINDOW[1]], [WINDOW[2], WINDOW[1]], [WINDOW[2], WINDOW[3]], [WINDOW[0], WINDOW[3]]],
             "walk_to": [460, 900]},
            {"id": "exit_east", "name": "To the gatehouse", "polygon": [[1825, 560], [1920, 560], [1920, 1062], [1825, 1062]],
             "walk_to": [1860, 980], "exit": {"room": "greybox_gate", "entry": "from_chapel", "direction": "right"}},
        ],
    }


def courtyard_room() -> dict:
    img = np.zeros((H, W), np.float32)
    img[:HORIZON] = np.linspace(0.34, 0.6, HORIZON)[:, None]
    img[HORIZON:] = np.linspace(0.3, 0.42, H - HORIZON)[:, None]
    for x0, top in ((300, 420), (620, 480), (1300, 380), (1620, 460)):  # distant walls
        box(img, (x0, top, x0 + 260, HORIZON), 0.22)
    poly(img, PATH, 0.5)
    box(img, (0, 420, 150, 1062), 0.1)  # the open gate behind
    art = "content/rooms/greybox_courtyard/art"
    save(ROOT / art / "bg_now.png", finish(img))
    return {
        "display_name": "Courtyard",
        "layers": {"now": [{"name": "Background", "texture": f"res://{art}/bg_now.png"}]},
        "walk": {"now": WALK},
        "scale_zones": SCALE,
        "markers": {"default": [500, 960], "from_gate": [260, 980]},
        "hotspots": [
            {"id": "path", "name": "The way on", "polygon": PATH, "walk_to": [940, 900]},
            {"id": "exit_gate", "name": "Back through the gate", "polygon": [[0, 420], [150, 420], [150, 1062], [0, 1062]],
             "walk_to": [80, 980], "exit": {"room": "greybox_gate", "entry": "from_courtyard", "direction": "left"}},
        ],
    }


def items() -> list[dict]:
    def cloth(shade: float, sheen: bool):
        def draw(value, alpha):
            points = np.array([[30, 20], [96, 24], [110, 70], [100, 112], [40, 108], [18, 66]], np.int32)
            cv2.fillPoly(value, [points], shade, cv2.LINE_AA)
            cv2.fillPoly(alpha, [points], 1.0, cv2.LINE_AA)
            for x in (44, 64, 84):
                cv2.line(value, (x, 30), (x - 8, 104), shade * 0.8, 3, cv2.LINE_AA)
            if sheen:
                cv2.line(value, (36, 50), (92, 44), 0.85, 4, cv2.LINE_AA)
        return draw

    def flask(value, alpha):
        for shape, shade in ((np.array([[34, 50], [94, 50], [102, 118], [26, 118]], np.int32), 0.6),
                             (np.array([[52, 14], [76, 14], [76, 52], [52, 52]], np.int32), 0.55)):
            cv2.fillPoly(value, [shape], shade, cv2.LINE_AA)
            cv2.fillPoly(alpha, [shape], 1.0, cv2.LINE_AA)
        cv2.line(value, (40, 62), (36, 110), 0.9, 4, cv2.LINE_AA)

    specs = [
        ("rag", "Rag", cloth(0.66, False), {"oil": "oiled_rag"}),
        ("oil", "Oil flask", flask, {"rag": "oiled_rag"}),
        ("oiled_rag", "Oiled rag", cloth(0.36, True), {}),
    ]
    result = []
    for item_id, name, draw, combinations in specs:
        save(ROOT / f"content/items/{item_id}/icon.png", prop(draw, (128, 128)))
        result.append({"id": item_id, "name": name, "icon": f"res://content/items/{item_id}/icon.png",
                       "look_file": "greybox", "look_cue": f"{item_id}_look", "combinations": combinations})
    return result


def main() -> None:
    for room_id, spec in (("greybox_gate", gate_room()), ("greybox_chapel", chapel_room()), ("greybox_courtyard", courtyard_room())):
        out = WORK / "rooms" / room_id / "room_spec.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(spec, indent=2) + "\n")
        print(out)
    out = WORK / "greybox" / "items.json"
    out.write_text(json.dumps(items(), indent=2) + "\n")
    print(out)


if __name__ == "__main__":
    main()
