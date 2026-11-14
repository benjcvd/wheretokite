import { handle } from "/Users/ben/Documents/claude_projects/atlas/data/worktrees/wheretokite-22959feecfb9/tickets/whe-159/server/src/index.ts";
import { MemoryCache } from "/Users/ben/Documents/claude_projects/atlas/data/worktrees/wheretokite-22959feecfb9/tickets/whe-159/server/src/util.ts";
const upstream: { url: string; body: string }[] = [];
const fakeFetch = (async (url: any, init: any) => {
  const body = String(init?.body ?? "");
  upstream.push({ url: String(url), body });
  const n = new URLSearchParams(body).get("latitude")!.split(",").length;
  const one = { latitude: 0, longitude: 0, hourly: { time: [] } };
  return new Response(JSON.stringify(n === 1 ? one : Array(n).fill(one)), { status: 200 });
}) as typeof fetch;
const deps = { cache: new MemoryCache(), fetch: fakeFetch, now: Date.now, waitUntil: () => {} };
const env = {} as any;
// 1. Arbitrary Open-Meteo parameters the app never sends, 400 fresh locations, no auth, no rate limit.
const mk = (r: number) => Array.from({ length: 400 }, (_, i) => (40 + r + i * 0.0001).toFixed(4)).join(",");
const lons = Array(400).fill("2.0000").join(",");
const q = (r: number) => `latitude=${mk(r)}&longitude=${lons}&hourly=temperature_2m,relative_humidity_2m,soil_moisture_0_to_1cm&forecast_days=16&models=icon_seamless`;
for (let r = 0; r < 3; r++) {
  const res = await handle(new Request("https://x.workers.dev/v1/forecast", { method: "POST", headers: { "content-type": "application/x-www-form-urlencoded" }, body: q(r) }), env, deps);
  console.log(`request ${r + 1}: HTTP ${res.status}, X-Cache ${res.headers.get("x-cache")}`);
}
console.log(`upstream calls: ${upstream.length}; locations sent upstream: ${upstream.reduce((s, u) => s + new URLSearchParams(u.body).get("latitude")!.split(",").length, 0)}`);
console.log(`forwarded params of first upstream call: ${[...new URLSearchParams(upstream[0].body).keys()].join(", ")}`);
console.log(`hourly forwarded: ${new URLSearchParams(upstream[0].body).get("hourly")}`);
