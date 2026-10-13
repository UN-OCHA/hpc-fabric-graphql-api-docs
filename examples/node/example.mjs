// Sign in at https://developer-api.humanitarianaction.info and subscribe for a key.
// Alternatively ask the API developers for a key, or use the key shared with you.
// Set APIM_SUBSCRIPTION_KEY in your environment. Never commit a real key.
import { readFile } from "node:fs/promises";

const endpoint = process.env.APIM_ENDPOINT || "https://api.humanitarianaction.info/graphql/v1";
const key = process.env.APIM_SUBSCRIPTION_KEY?.trim();
const [example = "currency", value, limit] = process.argv.slice(2);

// Send the query and variables as JSON. Variables avoid constructing queries
// by concatenating user input into the GraphQL text.
async function execute(queryFile, variables) {
  const query = await readFile(new URL(`../queries/${queryFile}`, import.meta.url), "utf8");
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      "Ocp-Apim-Subscription-Key": key,
    },
    body: JSON.stringify({ query, variables }),
    signal: AbortSignal.timeout(110_000),
  });
  const text = await response.text();
  if (!response.ok) throw new Error(`HTTP ${response.status}: ${text}`);
  let body;
  try { body = JSON.parse(text); } catch { throw new Error("The API response was not valid JSON."); }
  if (body.errors?.length) throw new Error(`GraphQL errors: ${JSON.stringify(body.errors)}`);
  if (!body.data || typeof body.data !== "object" || Array.isArray(body.data))
    throw new Error("The response did not contain a GraphQL data object.");
  return body.data;
}

function positiveInteger(value, name) {
  const number = Number(value);
  if (!Number.isInteger(number) || number < 1 || number > 2_147_483_647)
    throw new Error(`${name} must be a positive 32-bit integer.`);
  return number;
}

async function main() {
  if (example === "--help" || example === "-h") {
    console.log("node example.mjs currency USD | plan 1202 | currencies 100 1000");
    console.log("Sign in and subscribe at https://developer-api.humanitarianaction.info for a key.");
    return;
  }
  if (!["currency", "plan", "currencies"].includes(example))
    throw new Error("Choose currency, plan, or currencies. Use --help.");
  if (!key || key === "replace-with-your-subscription-key")
    throw new Error("Set APIM_SUBSCRIPTION_KEY. Sign in and subscribe at https://developer-api.humanitarianaction.info, or ask the API developers for a key.");

  let result;
  if (example === "currency") {
    const code = (value ?? "USD").trim().toUpperCase();
    if (!code) throw new Error("Currency code cannot be empty.");
    result = await execute("currency-by-code.graphql", { code });
  } else if (example === "plan") {
    result = await execute("plan-by-id.graphql", { planId: positiveInteger(value ?? 1202, "Plan ID") });
  } else {
    const pageSize = positiveInteger(value ?? 100, "Page size");
    const maxRecords = positiveInteger(limit ?? 1000, "Max records");
    if (pageSize > 1000) throw new Error("Page size must be 1–1000.");
    const items = [];
    const cursors = new Set();
    let after = null;
    let hasNextPage = false;
    // Each page is a separate API request. Stop at maxRecords to bound usage.
    do {
      const first = Math.min(pageSize, maxRecords - items.length);
      const data = await execute("currencies-page.graphql", { first, after });
      const page = data.currencies;
      if (!page || !Array.isArray(page.items)) throw new Error("Missing currencies items array.");
      items.push(...page.items.slice(0, first));
      hasNextPage = Boolean(page.hasNextPage);
      if (!hasNextPage || items.length >= maxRecords) break;
      after = page.endCursor;
      if (!after || cursors.has(after)) throw new Error("Pagination stopped: missing or repeated cursor.");
      cursors.add(after);
    } while (true);
    result = { items, returnedCount: items.length, hasNextPage, stoppedAtConfiguredLimit: hasNextPage && items.length >= maxRecords };
  }
  console.log(JSON.stringify(result, null, 2));
}

main().catch((error) => {
  console.error(`Query failed: ${error.message}`);
  process.exitCode = 1;
});

