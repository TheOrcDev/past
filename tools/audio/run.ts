// The audio pipeline's command line (audio-pipeline.md §3). Run from the
// repository root, so Bun loads the operator's .env:
//   bun tools/audio/run.ts extract   writes audio-source/voice/manifest.json
//   bun tools/audio/run.ts diff      lines `voice` would generate: new or changed
//   bun tools/audio/run.ts report    credits used, from the subscription endpoint
// Plan 003 adds ids, cast, voice, sfx, music, check, post and lint.

import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname } from "node:path";
import { CONCURRENCY, ElevenLabs } from "./src/client";
import { buildManifest, diff, type LockEntry, type ManifestEntry } from "./src/manifest";
import { configPath, dialogueDir, lockPath, manifestPath, repoRoot } from "./src/paths";

const config = JSON.parse(readFileSync(configPath, "utf8")) as { player: string; tier: string };

function readJson<T>(path: string, fallback: T): T {
  return existsSync(path) ? (JSON.parse(readFileSync(path, "utf8")) as T) : fallback;
}

async function main(command: string | undefined): Promise<number> {
  switch (command) {
    case "extract": {
      const manifest = buildManifest(dialogueDir, repoRoot, config.player);
      mkdirSync(dirname(manifestPath), { recursive: true });
      writeFileSync(manifestPath, JSON.stringify(manifest, null, 2) + "\n");
      console.log(`extract: ${manifest.length} lines -> ${manifestPath}`);
      return 0;
    }
    case "diff": {
      const manifest = readJson<ManifestEntry[]>(manifestPath, []);
      const result = diff(manifest, readJson<Record<string, LockEntry>>(lockPath, {}));
      console.log(`diff: ${result.added.length} new, ${result.changed.length} changed, ${result.removed.length} removed, ${result.unchanged.length} unchanged`);
      for (const id of [...result.added, ...result.changed]) console.log(`  voice ${id}`);
      for (const id of result.removed) console.log(`  orphan ${id}`);
      return 0;
    }
    case "report": {
      const client = new ElevenLabs({ apiKey: process.env.ELEVENLABS_API_KEY ?? "", concurrency: CONCURRENCY[config.tier] });
      const sub = await client.subscription();
      const reset = sub.next_character_count_reset_unix ? new Date(sub.next_character_count_reset_unix * 1000).toISOString() : "unknown";
      console.log(`report: ${sub.tier}, ${sub.character_count} of ${sub.character_limit} credits used, resets ${reset}`);
      return 0;
    }
    default:
      console.error("usage: bun tools/audio/run.ts <extract|diff|report>");
      return 2;
  }
}

process.exit(await main(process.argv[2]).catch((error: Error) => {
  console.error(`audio: ${error.message}`);
  return 1;
}));
