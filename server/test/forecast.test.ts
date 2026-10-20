import { describe, expect, it, vi } from "vitest";
import {
  cacheKey,
  chunk,
  MAX_LOCATIONS,
  parseParams,
  reassemble,
  splitUpstream,
  upstreamBody,
} from "../src/forecast";
import { handle, type Deps } from "../src/index";
import { MemoryCache } from "../src/util";

const ORIGIN = "https://api.test";
const APP_PARAMS =
  "hourly=wind_speed_10m,wind_gusts_10m,wind_direction_10m&wind_speed_unit=kn&timezone=auto" +
  "&start_date=2026-10-19&end_date=2026-10-19&models=best_match&cell_selection=sea";

describe("parseParams / cacheKey", () => {
  it("rounds coordinates to 4 decimals and splits locations", () => {
    const p = parseParams(new URLSearchParams("latitude=43.123456,-0.00001&longitude=-1.5,2&hourly=a"), "forecast");
    expect(p.locations.map((l) => [l.lat, l.lon])).toEqual([
      ["43.1235", "-1.5000"],
      ["0.0000", "2.0000"],
    ]);
  });

  it("gives the same key regardless of parameter order, whitespace, repeats or apikey", () => {
    const a = parseParams(new URLSearchParams("latitude=1&longitude=2&hourly=x,y&models=m&apikey=secret"), "forecast");
    const b = parseParams(new URLSearchParams("models= m &hourly=x&hourly=y&longitude=2.00001&latitude=1.0"), "forecast");
    expect(cacheKey(ORIGIN, a, a.locations[0])).toBe(cacheKey(ORIGIN, b, b.locations[0]));
    expect(cacheKey(ORIGIN, a, a.locations[0])).not.toContain("secret");
  });

  it("keys differ by endpoint, by any parameter, and by location", () => {
    const f = parseParams(new URLSearchParams("latitude=1&longitude=2&hourly=x"), "forecast");
    const a = parseParams(new URLSearchParams("latitude=1&longitude=2&hourly=x"), "archive");
    const g = parseParams(new URLSearchParams("latitude=1&longitude=2&hourly=x&wind_speed_unit=kn"), "forecast");
    const l = parseParams(new URLSearchParams("latitude=1.0001&longitude=2&hourly=x"), "forecast");
    const keys = [f, a, g, l].map((p) => cacheKey(ORIGIN, p, p.locations[0]));
    expect(new Set(keys).size).toBe(4);
  });

  it("keeps the order inside lists (it is the order of the response keys)", () => {
    const p = parseParams(new URLSearchParams("latitude=1&longitude=2&hourly=b,a"), "forecast");
    expect(p.shared).toEqual([["hourly", "b,a"]]);
  });

  it("puts per-location timezone/elevation in each location's key", () => {
    const p = parseParams(
      new URLSearchParams("latitude=1,3&longitude=2,4&timezone=Europe/Paris,Europe/Berlin&elevation=10,20"),
      "forecast",
    );
    expect(p.locations[1].extra).toEqual([
      ["elevation", "20"],
      ["timezone", "Europe/Berlin"],
    ]);
    expect(cacheKey(ORIGIN, p, p.locations[1])).toContain("timezone=Europe%2FBerlin");
    // a single timezone applies to every location
    const q = parseParams(new URLSearchParams("latitude=1,3&longitude=2,4&timezone=auto"), "forecast");
    expect(q.locations.map((l) => l.extra)).toEqual([[["timezone", "auto"]], [["timezone", "auto"]]]);
  });
});

describe("validation", () => {
  const bad = (q: string) => () => parseParams(new URLSearchParams(q), "forecast");
  it("rejects missing, mismatched, non-numeric and out-of-range coordinates", () => {
    expect(bad("hourly=x")).toThrow(/required/);
    expect(bad("latitude=1,2&longitude=3")).toThrow(/same number/);
    expect(bad("latitude=abc&longitude=3")).toThrow(/must be a number/);
    expect(bad("latitude=1e3&longitude=3")).toThrow(/must be a number/);
    expect(bad("latitude=91&longitude=3")).toThrow(/between -90 and 90/);
    expect(bad("latitude=1&longitude=-180.5")).toThrow(/between -180 and 180/);
    expect(bad("latitude=1,&longitude=3,4")).toThrow(/must be a number/);
  });
  it("rejects too many locations, mismatched elevation, non-JSON formats", () => {
    const n = MAX_LOCATIONS + 1;
    const many = Array.from({ length: n }, () => "1").join(",");
    expect(bad(`latitude=${many}&longitude=${many}`)).toThrow(/At most 400/);
    expect(bad("latitude=1,2&longitude=3,4&elevation=5")).toThrow(/elevation/);
    expect(bad("latitude=1&longitude=3&format=csv")).toThrow(/format=json/);
  });
});

describe("chunking, upstream body, split and reassembly", () => {
  it("chunks into pieces of at most n", () => {
    expect(chunk([1, 2, 3, 4, 5], 2)).toEqual([[1, 2], [3, 4], [5]]);
    expect(chunk(Array.from({ length: 250 }, (_, i) => i), 100).map((c) => c.length)).toEqual([100, 100, 50]);
    expect(chunk([], 100)).toEqual([]);
  });

  it("builds a multi-location form body with per-location lists and the key", () => {
    const p = parseParams(new URLSearchParams("latitude=1,3&longitude=2,4&hourly=x&timezone=auto"), "forecast");
    const body = new URLSearchParams(upstreamBody(p.shared, p.locations, "K"));
    expect(body.get("latitude")).toBe("1.0000,3.0000");
    expect(body.get("longitude")).toBe("2.0000,4.0000");
    expect(body.get("timezone")).toBe("auto,auto");
    expect(body.get("apikey")).toBe("K");
    expect(new URLSearchParams(upstreamBody(p.shared, p.locations)).has("apikey")).toBe(false);
  });

  it("splits upstream responses and strips location_id", () => {
    expect(splitUpstream({ a: 1 }, 1)).toEqual(['{"a":1}']);
    expect(splitUpstream([{ a: 1 }, { a: 2, location_id: 1 }], 2)).toEqual(['{"a":1}', '{"a":2}']);
    expect(() => splitUpstream([{ a: 1 }], 2)).toThrow(/expected 2/);
  });

  it("reassembles like Open-Meteo: object for one, array with location_id from index 1", () => {
    expect(reassemble(['{"a":1}'])).toBe('{"a":1}');
    expect(JSON.parse(reassemble(['{"a":1}', '{"a":2}', '{"a":3}']))).toEqual([
      { a: 1 },
      { a: 2, location_id: 1 },
      { a: 3, location_id: 2 },
    ]);
  });
});

// ---- Handler with a fake upstream ----

/** Fake Open-Meteo: echoes each location's coordinates so order can be checked. */
function fakeUpstream() {
  const calls: URLSearchParams[] = [];
  const fetch = vi.fn(async (_url: string | URL | Request, init?: RequestInit) => {
    const body = new URLSearchParams(String(init!.body));
    calls.push(body);
    const lats = body.get("latitude")!.split(",");
    const lons = body.get("longitude")!.split(",");
    const items = lats.map((lat, i) => ({
      latitude: Number(lat),
      longitude: Number(lons[i]),
      hourly: { time: ["t"], wind_speed_10m: [Number(lat)] },
      ...(i > 0 ? { location_id: i } : {}),
    }));
    return new Response(JSON.stringify(items.length === 1 ? items[0] : items), {
      headers: { "Content-Type": "application/json" },
    });
  });
  return { fetch, calls };
}

function makeDeps(fetchImpl: Deps["fetch"], now = () => 1_000_000_000_000): Deps & { pending: Promise<unknown>[] } {
  const pending: Promise<unknown>[] = [];
  return { cache: new MemoryCache(10_000, now), fetch: fetchImpl, now, waitUntil: (p) => pending.push(p), pending };
}

const lats = (n: number, from = 0) => Array.from({ length: n }, (_, i) => (from + i * 0.01).toFixed(4)).join(",");

describe("handleForecast", () => {
  it("MISS then HIT, with the same body and no second upstream call", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const url = `${ORIGIN}/v1/forecast?latitude=43.1,44.2,45.3&longitude=1,2,3&${APP_PARAMS}`;
    const r1 = await handle(new Request(url), {}, deps);
    expect(r1.status).toBe(200);
    expect(r1.headers.get("x-cache")).toBe("MISS");
    const b1 = await r1.text();
    const r2 = await handle(new Request(url), {}, deps);
    expect(r2.headers.get("x-cache")).toBe("HIT");
    expect(await r2.text()).toBe(b1);
    expect(up.calls).toHaveLength(1);
    expect(JSON.parse(b1).map((x: { latitude: number }) => x.latitude)).toEqual([43.1, 44.2, 45.3]);
  });

  it("PARTIAL: fetches only missing locations and reassembles in the caller's order", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    await handle(new Request(`${ORIGIN}/v1/forecast?latitude=10,30&longitude=0,0&hourly=x`), {}, deps);
    const res = await handle(
      new Request(`${ORIGIN}/v1/forecast`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "latitude=30,20,10,40&longitude=0,0,0,0&hourly=x",
      }),
      {},
      deps,
    );
    expect(res.headers.get("x-cache")).toBe("PARTIAL");
    expect(res.headers.get("x-cache-hits")).toBe("2/4");
    expect(up.calls[1].get("latitude")).toBe("20.0000,40.0000");
    const body = JSON.parse(await res.text());
    expect(body.map((x: { latitude: number }) => x.latitude)).toEqual([30, 20, 10, 40]);
    expect(body.map((x: { location_id?: number }) => x.location_id)).toEqual([undefined, 1, 2, 3]);
  });

  it("single location returns an object", async () => {
    const deps = makeDeps(fakeUpstream().fetch);
    const res = await handle(new Request(`${ORIGIN}/v1/marine?latitude=43.5&longitude=-1.6&hourly=sea_level_height_msl`), {}, deps);
    const body = JSON.parse(await res.text());
    expect(Array.isArray(body)).toBe(false);
    expect(body.latitude).toBe(43.5);
  });

  it("chunks 250 missing locations into 3 upstream calls of <= 100", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const res = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=${lats(250)}&longitude=${lats(250)}&hourly=x`), {}, deps);
    expect(res.status).toBe(200);
    expect(up.calls.map((c) => c.get("latitude")!.split(",").length)).toEqual([100, 100, 50]);
    const body = JSON.parse(await res.text());
    expect(body).toHaveLength(250);
    expect(body[249].latitude).toBeCloseTo(2.49);
  });

  it("uses customer endpoints and apikey when OPEN_METEO_API_KEY is set", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    await handle(new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=2&hourly=x`), { OPEN_METEO_API_KEY: "K" }, deps);
    await handle(new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=3&hourly=x`), {}, deps);
    expect(up.fetch.mock.calls[0][0]).toBe("https://customer-historical-forecast-api.open-meteo.com/v1/forecast");
    expect(up.calls[0].get("apikey")).toBe("K");
    expect(up.fetch.mock.calls[1][0]).toBe("https://historical-forecast-api.open-meteo.com/v1/forecast");
  });

  it("expires entries after the TTL (1 h forecast, 24 h archive)", async () => {
    let t = 1_000_000_000_000;
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch, () => t);
    const f = new Request(`${ORIGIN}/v1/forecast?latitude=1&longitude=2&hourly=x`);
    const a = new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=2&hourly=x`);
    await handle(f.clone(), {}, deps);
    await handle(a.clone(), {}, deps);
    t += 3599_000;
    expect((await handle(f.clone(), {}, deps)).headers.get("x-cache")).toBe("HIT");
    t += 2_000;
    expect((await handle(f.clone(), {}, deps)).headers.get("x-cache")).toBe("MISS");
    expect((await handle(a.clone(), {}, deps)).headers.get("x-cache")).toBe("HIT");
    t += 86400_000;
    expect((await handle(a.clone(), {}, deps)).headers.get("x-cache")).toBe("MISS");
  });

  it("passes upstream errors through and caches nothing", async () => {
    const err = '{"reason":"Invalid value","error":true}';
    const fetchImpl = vi.fn(async () => new Response(err, { status: 400, headers: { "Content-Type": "application/json" } }));
    const deps = makeDeps(fetchImpl);
    const url = `${ORIGIN}/v1/forecast?latitude=1&longitude=2&hourly=foo`;
    const res = await handle(new Request(url), {}, deps);
    expect(res.status).toBe(400);
    expect(await res.text()).toBe(err);
    await handle(new Request(url), {}, deps);
    expect(fetchImpl).toHaveBeenCalledTimes(2);
  });

  it("returns Open-Meteo-like errors for bad input, unknown endpoints and methods", async () => {
    const deps = makeDeps(fakeUpstream().fetch);
    const r1 = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=x&longitude=2`), {}, deps);
    expect(r1.status).toBe(400);
    expect(await r1.json()).toMatchObject({ error: true });
    const r2 = await handle(new Request(`${ORIGIN}/v1/air-quality?latitude=1&longitude=2`), {}, deps);
    expect(r2.status).toBe(404);
    expect(await r2.json()).toMatchObject({ error: true });
    const r3 = await handle(new Request(`${ORIGIN}/v1/forecast`, { method: "PUT" }), {}, deps);
    expect(r3.status).toBe(405);
    const r4 = await handle(
      new Request(`${ORIGIN}/v1/forecast`, { method: "POST", body: "x".repeat(70_000), headers: { "Content-Type": "application/x-www-form-urlencoded" } }),
      {},
      deps,
    );
    expect(r4.status).toBe(413);
  });

  it("maps a network failure to 502", async () => {
    const deps = makeDeps(vi.fn(async () => { throw new TypeError("network"); }));
    const res = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=1&longitude=2`), {}, deps);
    expect(res.status).toBe(502);
  });

  it("health", async () => {
    const res = await handle(new Request(`${ORIGIN}/v1/health`), {}, makeDeps(fakeUpstream().fetch));
    expect(await res.json()).toEqual({ ok: true });
  });
});

describe("edge cache budget", () => {
  it("stops calling the Cache API past the per-request budget, memory still shared", async () => {
    const { TieredCache } = await import("../src/util");
    let calls = 0;
    const edge = {
      match: async () => { calls++; return undefined; },
      put: async () => { calls++; },
    } as unknown as globalThis.Cache;
    const shared = new TieredCache(edge);
    const view = shared.forRequest(3);
    for (let i = 0; i < 10; i++) await view.get(`https://x/k${i}`);
    expect(calls).toBe(3);
    await view.put("https://x/k0", { body: "x", fetchedAt: Date.now() }, 60);
    expect(calls).toBe(3);                                  // over budget: memory only
    expect((await shared.forRequest(0).get("https://x/k0"))?.body).toBe("x");   // shared memory tier
    expect(calls).toBe(3);
  });
});
