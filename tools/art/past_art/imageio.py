"""Reading and writing images as numpy arrays (BGR/BGRA/grey, uint8) with OpenCV."""

from pathlib import Path

import cv2
import numpy as np


def load(path: str | Path) -> np.ndarray:
    image = cv2.imread(str(path), cv2.IMREAD_UNCHANGED)
    if image is None:
        raise FileNotFoundError(f"cannot read image {path}")
    if image.dtype != np.uint8:
        image = cv2.convertScaleAbs(image, alpha=255.0 / np.iinfo(image.dtype).max)
    return image


def save(path: str | Path, image: np.ndarray) -> None:
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    if not cv2.imwrite(str(path), image):
        raise OSError(f"cannot write image {path}")


def to_bgr(image: np.ndarray) -> np.ndarray:
    """Drops alpha and expands grey, so every image can be treated as BGR."""
    if image.ndim == 2:
        return cv2.cvtColor(image, cv2.COLOR_GRAY2BGR)
    if image.shape[2] == 4:
        return image[:, :, :3].copy()
    return image


def luminance(image: np.ndarray) -> np.ndarray:
    """Rec. 709 luma as float32 in 0–255."""
    if image.ndim == 2:
        return image.astype(np.float32)
    b, g, r = [image[:, :, i].astype(np.float32) for i in range(3)]
    return 0.0722 * b + 0.7152 * g + 0.2126 * r
