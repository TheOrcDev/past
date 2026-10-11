import { resolve } from "node:path";

/** Repository root, from tools/audio/src. */
export const repoRoot = resolve(import.meta.dir, "..", "..", "..");
export const dialogueDir = resolve(repoRoot, "content/dialogue");
export const audioSource = resolve(repoRoot, "audio-source");
export const manifestPath = resolve(audioSource, "voice/manifest.json");
export const lockPath = resolve(audioSource, "voice/lock.json");
export const cacheDir = resolve(audioSource, "cache");
export const configPath = resolve(import.meta.dir, "..", "config.json");
