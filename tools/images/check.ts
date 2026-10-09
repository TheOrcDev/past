// Confirms the gateway key works and the GPT Image models are listed, without
// generating anything. Usage, from the repository root: bun tools/images/check.ts
import { gateway } from "ai";
import { fetchPricing } from "./src/pricing";

const MODELS = ["openai/gpt-image-2.5-flare", "openai/gpt-image-2.5-sunburst", "openai/gpt-image-2"];

for (const model of MODELS) {
  const pricing = await fetchPricing(model);
  console.log(`${model}: ${pricing.source === "gateway" ? "listed" : "NOT LISTED"} ($${(pricing.outputUsdPerToken * 1e6).toFixed(2)}/M output tokens)`);
}

if (!process.env.AI_GATEWAY_API_KEY) {
  console.error("AI_GATEWAY_API_KEY: not set (run from the repository root with the key in .env)");
  process.exit(4);
}
console.log("AI_GATEWAY_API_KEY: set");
try {
  const credits = await gateway.getCredits();
  console.log(`gateway credits: balance $${credits.balance}, used $${credits.totalUsed}`);
} catch (error) {
  console.error(`gateway authentication failed: ${(error as Error).message}`);
  process.exit(5);
}
