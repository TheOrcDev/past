import cv2
import numpy as np
import pytest

from past_art import align, grade, masks, rings
from past_art.cli import main


def texture(w: int = 640, h: int = 400, seed: int = 7) -> np.ndarray:
    """A detailed synthetic image with plenty of corners for SIFT."""
    rng = np.random.default_rng(seed)
    noise = rng.integers(0, 256, (h // 8, w // 8, 3), dtype=np.uint8)
    image = cv2.resize(noise, (w, h), interpolation=cv2.INTER_CUBIC)
    for _ in range(60):
        x, y = int(rng.integers(0, w)), int(rng.integers(0, h))
        cv2.circle(image, (x, y), int(rng.integers(4, 18)), tuple(int(v) for v in rng.integers(0, 256, 3)), -1)
    return image


def shifted(image: np.ndarray, dx: float, dy: float, angle: float = 0.0) -> np.ndarray:
    h, w = image.shape[:2]
    m = cv2.getRotationMatrix2D((w / 2, h / 2), angle, 1.0)
    m[:, 2] += (dx, dy)
    return cv2.warpAffine(image, m, (w, h), borderMode=cv2.BORDER_REFLECT)


def test_register_recovers_a_small_shift_and_rotation():
    fixed = texture()
    moving = shifted(fixed, 6, -4, angle=0.8)
    registration = align.register(fixed, moving)
    assert registration.residual_p90_px < 1.0
    assert abs(registration.rotation_deg - 0.8) < 0.1  # maps moving back onto fixed
    warped = align.warp(moving, registration, (fixed.shape[1], fixed.shape[0]))
    error = np.abs(warped[40:-40, 40:-40].astype(int) - fixed[40:-40, 40:-40].astype(int)).mean()
    assert error < 6


def test_monochrome_and_resize():
    image = texture()
    mono = grade.monochrome(grade.resize(image, (320, 200)))
    assert mono.shape == (200, 320)
    assert grade.saturation_percent(mono) == 0.0
    assert grade.saturation_percent(image) > 10


def test_region_luminance_reads_inside_the_mask_only():
    image = np.zeros((100, 100), np.uint8)
    image[50:, :] = 200
    stats = grade.region_luminance(image, masks.polygon_mask((100, 100), [[0, 60], [100, 60], [100, 100], [0, 100]]))
    assert stats["median"] == pytest.approx(200, abs=1)


def test_cut_returns_rgba_and_its_box():
    image = texture(200, 100)
    rgba, rect = masks.cut(image, masks.polygon_mask((200, 100), [[20, 10], [80, 10], [80, 60], [20, 60]]))
    assert rgba.shape[2] == 4
    assert rect[0] == pytest.approx(20, abs=1) and rect[1] == pytest.approx(10, abs=1)
    assert rect[2] == pytest.approx(61, abs=2) and rect[3] == pytest.approx(51, abs=2)


def test_prepare_ring_aligns_levels_and_feathers():
    outer = texture(1024, 640)
    rect = (256, 160, 512, 320)
    x, y, w, h = rect
    true_inner = cv2.resize(outer[y : y + h, x : x + w], (1024, 640), interpolation=cv2.INTER_CUBIC)
    inner = cv2.convertScaleAbs(shifted(true_inner, 5, 3), alpha=1.2, beta=15)  # misaligned and brighter
    ring, registration = rings.prepare_ring(outer, inner, rect)
    assert registration.residual_p90_px < 1.5
    assert ring.shape == (640, 1024, 4)
    assert ring[0, 0, 3] == 0 and ring[320, 512, 3] == 255
    core = (slice(80, -80), slice(80, -80))
    assert abs(float(ring[core][:, :, :3].mean()) - float(true_inner[core].mean())) < 6


def test_cli_align_fails_above_the_threshold(tmp_path):
    a, b = tmp_path / "a.png", tmp_path / "b.png"
    fixed = texture()
    cv2.imwrite(str(a), fixed)
    cv2.imwrite(str(b), shifted(fixed, 3, 2))
    assert main(["align", "--fixed", str(a), "--moving", str(b), "--max-p90", "3"]) == 0
    assert main(["align", "--fixed", str(a), "--moving", str(b), "--max-p90", "0.0001"]) == 1
