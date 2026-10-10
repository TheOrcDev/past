"""past-art: image processing for Past (docs/art-pipeline.md §7).

Run from the repository root:  uv run --project tools/art past-art <command> --help
"""

import argparse
import json
import sys
from pathlib import Path

from . import align, grade, masks, pack, rings, sheet
from .imageio import load, save


def _size(text: str) -> tuple[int, int]:
    w, h = text.lower().split("x")
    return int(w), int(h)


def _rect(text: str) -> tuple[int, int, int, int]:
    x, y, w, h = (int(v) for v in text.split(","))
    return x, y, w, h


def _polygon(text: str) -> list[list[float]]:
    """A JSON list of [x, y] points, inline or from a file."""
    path = Path(text)
    return json.loads(path.read_text() if path.exists() else text)


def _print(data: dict) -> None:
    print(json.dumps(data, indent=2))


def cmd_align(args: argparse.Namespace) -> int:
    fixed, moving = load(args.fixed), load(args.moving)
    registration = align.register(fixed, moving)
    report = registration.to_dict()
    report["passes"] = registration.residual_p90_px <= args.max_p90
    if args.out:
        save(args.out, align.warp(moving, registration, (fixed.shape[1], fixed.shape[0])))
    if args.report:
        Path(args.report).write_text(json.dumps(report, indent=2) + "\n")
    _print(report)
    return 0 if report["passes"] else 1


def cmd_grade(args: argparse.Namespace) -> int:
    image = load(args.input)
    report: dict = {"saturation_percent_before": round(grade.saturation_percent(image), 2)}
    out = grade.resize(image, _size(args.size)) if args.size else image
    if args.mono:
        out = grade.monochrome(out)
    save(args.out, out)
    if args.walk_polygon:
        h, w = out.shape[:2]
        polygon = _polygon(args.walk_polygon)
        report["walk_area_luminance"] = grade.region_luminance(out, masks.polygon_mask((w, h), polygon))
        # The band where Unknown's head and shoulders are seen: from the walk area's top edge up 40% of the frame height.
        top = min(p[1] for p in polygon)
        band = [[0, max(0, top - 0.4 * h)], [w, max(0, top - 0.4 * h)], [w, top], [0, top]]
        report["behind_figure_luminance"] = grade.region_luminance(out, masks.polygon_mask((w, h), band))
    report["out"] = str(args.out)
    _print(report)
    return 0


def cmd_mask(args: argparse.Namespace) -> int:
    save(args.out, masks.polygon_mask(_size(args.size), _polygon(args.polygon), args.feather))
    return 0


def cmd_cut(args: argparse.Namespace) -> int:
    image = load(args.input)
    h, w = image.shape[:2]
    rgba, rect = masks.cut(image, masks.polygon_mask((w, h), _polygon(args.polygon), args.feather))
    save(args.out, rgba)
    _print({"out": str(args.out), "rect": list(rect)})
    return 0


def cmd_ring(args: argparse.Namespace) -> int:
    outer, inner = load(args.outer), load(args.inner)
    rect = _rect(args.rect)
    ring, registration = rings.prepare_ring(outer, inner, rect, args.feather)
    save(args.out, ring)
    if args.preview:
        save(args.preview, rings.blend_preview(outer, ring, rect))
    report = registration.to_dict()
    report["rect_in_outer"] = list(rect)
    _print(report)
    return 0


def cmd_depth(args: argparse.Namespace) -> int:
    from . import depth

    image = load(args.input)
    save(args.out, depth.estimate(image if image.ndim == 2 else image[:, :, :3]))
    _print({"out": str(args.out), "model": depth.MODEL})
    return 0


def cmd_sheet(args: argparse.Namespace) -> int:
    images, labels = [], []
    for item in args.images:
        path, _, label = item.partition(":")
        images.append(load(path))
        labels.append(label or Path(path).stem)
    save(args.out, sheet.contact_sheet(images, labels, args.columns, _size(args.tile)))
    return 0


def cmd_pack(args: argparse.Namespace) -> int:
    renders = [Path(folder) for folder in args.renders]
    manifest = pack.pack(renders, Path(args.out_dir), Path(args.manifest), args.res_prefix, args.name)
    _print({key: {"fps": value["fps"], "frames": len(value["frames"])} for key, value in manifest["animations"].items()})
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="past-art", description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("align", help="register MOVING onto FIXED and report the residual")
    p.add_argument("--fixed", required=True)
    p.add_argument("--moving", required=True)
    p.add_argument("--out", help="write MOVING warped into FIXED's frame")
    p.add_argument("--report", help="write the report as JSON")
    p.add_argument("--max-p90", type=float, default=3.0, help="fail above this p90 residual (px)")
    p.set_defaults(func=cmd_align)

    p = sub.add_parser("grade", help="resize, optionally make monochrome, and measure the walk area")
    p.add_argument("--in", dest="input", required=True)
    p.add_argument("--out", required=True)
    p.add_argument("--size", help="WIDTHxHEIGHT")
    p.add_argument("--mono", action="store_true")
    p.add_argument("--walk-polygon", help="JSON points (in output pixels) of the walk area, inline or a file")
    p.set_defaults(func=cmd_grade)

    p = sub.add_parser("mask", help="write a polygon mask")
    p.add_argument("--size", required=True)
    p.add_argument("--polygon", required=True)
    p.add_argument("--feather", type=float, default=0.0)
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_mask)

    p = sub.add_parser("cut", help="cut a polygon out of an image as RGBA (for occluders)")
    p.add_argument("--in", dest="input", required=True)
    p.add_argument("--polygon", required=True)
    p.add_argument("--feather", type=float, default=1.5)
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_cut)

    p = sub.add_parser("ring", help="prepare an inner reveal ring for RECT of OUTER")
    p.add_argument("--outer", required=True)
    p.add_argument("--inner", required=True)
    p.add_argument("--rect", required=True, help="x,y,width,height in OUTER pixels")
    p.add_argument("--feather", type=float, default=0.08)
    p.add_argument("--out", required=True)
    p.add_argument("--preview")
    p.set_defaults(func=cmd_ring)

    p = sub.add_parser("depth", help="depth map (needs `uv sync --extra depth`)")
    p.add_argument("--in", dest="input", required=True)
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_depth)

    p = sub.add_parser("sheet", help="contact sheet; images as PATH[:LABEL]")
    p.add_argument("--out", required=True)
    p.add_argument("--columns", type=int, default=2)
    p.add_argument("--tile", default="960x540")
    p.add_argument("images", nargs="+")
    p.set_defaults(func=cmd_sheet)

    p = sub.add_parser("pack", help="pack rendered character frames into alpha-mask sprite sheets")
    p.add_argument("--renders", required=True, action="append",
                   help="folder with anchors.json and one subfolder per animation; repeat to replace animations")
    p.add_argument("--out-dir", required=True, help="where the sheets go")
    p.add_argument("--manifest", required=True, help="where the JSON manifest goes")
    p.add_argument("--res-prefix", required=True, help="res:// folder the sheets are loaded from")
    p.add_argument("--name", required=True)
    p.set_defaults(func=cmd_pack)

    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
