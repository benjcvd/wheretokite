import { describe, expect, it, vi } from "vitest";
import {
  cacheKey,
  checkAllowed,
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
const MARINE_PARAMS = "hourly=sea_level_height_msl&timezone=auto&start_date=2026-10-19&end_date=2026-10-25";
/** "Today" in these tests: 19 Oct 2026, noon UTC. */
const NOW = Date.UTC(2026, 9, 19, 12);

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
    expect(bad(`latitude=${many}&longitude=${many}`)).toThrow(/At most 150/);
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

function makeDeps(fetchImpl: Deps["fetch"], now = () => NOW): Deps & { pending: Promise<unknown>[] } {
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
    await handle(new Request(`${ORIGIN}/v1/forecast?latitude=10,30&longitude=0,0&${APP_PARAMS}`), {}, deps);
    const res = await handle(
      new Request(`${ORIGIN}/v1/forecast`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `latitude=30,20,10,40&longitude=0,0,0,0&${APP_PARAMS}`,
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
    const res = await handle(new Request(`${ORIGIN}/v1/marine?latitude=43.5&longitude=-1.6&${MARINE_PARAMS}`), {}, deps);
    const body = JSON.parse(await res.text());
    expect(Array.isArray(body)).toBe(false);
    expect(body.latitude).toBe(43.5);
  });

  it("wave heights for an app batch of 100 sea spots: one upstream call (WHE-221)", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const q = MARINE_PARAMS.replace("sea_level_height_msl", "wave_height");
    const res = await handle(new Request(`${ORIGIN}/v1/marine?latitude=${lats(100)}&longitude=${lats(100)}&${q}`), {}, deps);
    expect(res.status).toBe(200);
    expect(up.calls).toHaveLength(1);
    expect(up.calls[0].get("hourly")).toBe("wave_height");
    expect(JSON.parse(await res.text())).toHaveLength(100);
  });

  it("chunks 150 missing locations into 2 upstream calls of <= 100", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const res = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=${lats(150)}&longitude=${lats(150)}&${APP_PARAMS}`), {}, deps);
    expect(res.status).toBe(200);
    expect(up.calls.map((c) => c.get("latitude")!.split(",").length)).toEqual([100, 50]);
    const body = JSON.parse(await res.text());
    expect(body).toHaveLength(150);
    expect(body[149].latitude).toBeCloseTo(1.49);
  });

  it("uses customer endpoints and apikey when OPEN_METEO_API_KEY is set", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    await handle(new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=2&${APP_PARAMS}`), { OPEN_METEO_API_KEY: "K" }, deps);
    await handle(new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=3&${APP_PARAMS}`), {}, deps);
    expect(up.fetch.mock.calls[0][0]).toBe("https://customer-historical-forecast-api.open-meteo.com/v1/forecast");
    expect(up.calls[0].get("apikey")).toBe("K");
    expect(up.fetch.mock.calls[1][0]).toBe("https://historical-forecast-api.open-meteo.com/v1/forecast");
  });

  it("expires entries after the TTL (1 h forecast, 24 h archive)", async () => {
    let t = NOW;
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch, () => t);
    const f = new Request(`${ORIGIN}/v1/forecast?latitude=1&longitude=2&${APP_PARAMS}`);
    const a = new Request(`${ORIGIN}/v1/archive?latitude=1&longitude=2&${APP_PARAMS}`);
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
    const url = `${ORIGIN}/v1/forecast?latitude=1&longitude=2&${APP_PARAMS}`;
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
    const res = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=1&longitude=2&${APP_PARAMS}`), {}, deps);
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

// Exactly what KiteCore sends (Forecast.swift formBody / fetchSeaLevels, Confidence.swift).
const SWIFT_FORECAST =
  "hourly=wind_speed_10m,wind_gusts_10m,wind_direction_10m,weather_code,cape,precipitation&daily=sunrise,sunset" +
  "&wind_speed_unit=kn&timezone=auto&start_date=2026-10-19&end_date=2026-10-25";
const SWIFT_CONFIDENCE =
  "hourly=wind_speed_10m,wind_direction_10m&wind_speed_unit=kn&timezone=auto&start_date=2026-10-21&end_date=2026-10-21" +
  "&models=best_match,meteofrance_seamless,icon_seamless,ecmwf_ifs025&cell_selection=land";

describe("allow-list (only what the app and CLI send)", () => {
  const check = (q: string, endpoint: "forecast" | "archive" | "marine" = "forecast") => () =>
    checkAllowed(parseParams(new URLSearchParams(`latitude=1,2&longitude=3,4&${q}`), endpoint), NOW);

  it("accepts every request KiteCore makes", () => {
    expect(check(`${SWIFT_FORECAST}&models=meteofrance_seamless&cell_selection=land`)).not.toThrow();
    expect(check(`${SWIFT_FORECAST}&models=ecmwf_ifs,gfs_seamless&cell_selection=sea`)).not.toThrow();
    expect(check(SWIFT_CONFIDENCE)).not.toThrow();
    expect(check(MARINE_PARAMS, "marine")).not.toThrow();
    expect(check(MARINE_PARAMS.replace("sea_level_height_msl", "wave_height"), "marine")).not.toThrow();
    // CLI --day on a past day goes to the archive.
    expect(check(SWIFT_FORECAST.replace(/2026-10-19|2026-10-25/g, "2025-08-14"), "archive")).not.toThrow();
  });

  it("refuses other variables, parameters and models (the audit's probe)", () => {
    expect(check(`${SWIFT_FORECAST}&forecast_days=16`)).toThrow(/'forecast_days' is not supported/);
    expect(check(`${SWIFT_FORECAST}&past_days=92`)).toThrow(/not supported/);
    expect(check(SWIFT_FORECAST.replace("cape", "temperature_2m"))).toThrow(/'temperature_2m'/);
    expect(check(`${SWIFT_FORECAST}&hourly=soil_moisture_0_to_1cm`)).toThrow(/soil_moisture/);
    expect(check(`${SWIFT_FORECAST}&models=ukmo_seamless`)).toThrow(/'ukmo_seamless'/);
    expect(check(SWIFT_FORECAST.replace("unit=kn", "unit=ms"))).toThrow(/'ms'/);
    expect(check(`${SWIFT_FORECAST}&elevation=0,0`)).toThrow(/'elevation'/);
    expect(check(SWIFT_FORECAST.replace("timezone=auto", "timezone=Europe/Paris"))).toThrow(/timezone/);
    expect(check(`${MARINE_PARAMS}&daily=sunrise`, "marine")).toThrow(/'daily'/);
    expect(check(MARINE_PARAMS.replace("sea_level_height_msl", "wave_period"), "marine")).toThrow(/'wave_period'/);
  });

  it("requires hourly and both dates, and bounds the date range", () => {
    expect(check("hourly=cape&start_date=2026-10-19")).toThrow(/'end_date' is required/);
    expect(check("start_date=2026-10-19&end_date=2026-10-19")).toThrow(/'hourly' is required/);
    const range = (a: string, b: string, e: "forecast" | "archive" | "marine" = "forecast") =>
      check(`hourly=cape&start_date=${a}&end_date=${b}`, e);
    expect(range("2026-10-19", "2026-11-04")).not.toThrow();          // 16 days ahead
    expect(range("2026-10-19", "2026-11-05")).toThrow(/16 days/);
    expect(range("2026-10-20", "2026-10-19")).toThrow(/before/);
    expect(range("2026-10-16", "2026-10-16")).not.toThrow();          // west of UTC, a day behind
    expect(range("2026-10-15", "2026-10-15")).toThrow(/range/);
    expect(range("2020-12-31", "2021-01-01", "archive")).toThrow(/range/);
    expect(range("2021-01-01", "2021-01-17", "archive")).not.toThrow();
    expect(range("2021-01-01", "2021-12-31", "archive")).toThrow(/16 days/);
    expect(range("2026-02-30", "2026-03-01")).toThrow(/date/);
    expect(range("26-10-19", "2026-10-19")).toThrow(/date/);
  });

  it("caps locations at 150", () => {
    const q = (n: number) => `${ORIGIN}/v1/forecast?latitude=${lats(n)}&longitude=${lats(n)}&${APP_PARAMS}`;
    expect(MAX_LOCATIONS).toBe(150);
    return Promise.all([
      handle(new Request(q(150)), {}, makeDeps(fakeUpstream().fetch)).then((r) => expect(r.status).toBe(200)),
      handle(new Request(q(151)), {}, makeDeps(fakeUpstream().fetch)).then((r) => expect(r.status).toBe(400)),
    ]);
  });

  it("refuses before anything goes upstream", async () => {
    const up = fakeUpstream();
    const res = await handle(new Request(`${ORIGIN}/v1/forecast?latitude=1&longitude=2&${APP_PARAMS}&hourly=temperature_2m`), {}, makeDeps(up.fetch));
    expect(res.status).toBe(400);
    expect(await res.json()).toMatchObject({ error: true, reason: expect.stringMatching(/temperature_2m/) });
    expect(up.calls).toHaveLength(0);
  });
});

describe("per-IP limit on the forecast routes", () => {
  function limiter(allowed: number) {
    const keys: string[] = [];
    return { keys, limit: async ({ key }: { key: string }) => ({ success: keys.push(key) <= allowed }) };
  }
  const SEA = `${SWIFT_FORECAST}&models=ecmwf_ifs,gfs_seamless&cell_selection=sea`;
  const LAND = `${SWIFT_FORECAST}&models=meteofrance_seamless&cell_selection=land`;
  const post = (n: number, from = 0, ip = "203.0.113.7", path = "/v1/forecast", params = SEA) =>
    new Request(`${ORIGIN}${path}`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded", "cf-connecting-ip": ip },
      body: `latitude=${lats(n, from)}&longitude=${lats(n, from)}&${params}`,
    });

  it("an app batch of 100 spots: one upstream call, 2 units; the same batch again is free", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const l = limiter(100);
    const r1 = await handle(post(100), { FORECAST_LIMITER: l }, deps);
    expect(r1.status).toBe(200);
    expect(JSON.parse(await r1.text())).toHaveLength(100);
    expect(up.calls).toHaveLength(1);
    expect(l.keys).toEqual(["forecast:203.0.113.7", "forecast:203.0.113.7"]);
    const r2 = await handle(post(100), { FORECAST_LIMITER: l }, deps);
    expect(r2.headers.get("x-cache")).toBe("HIT");
    expect(l.keys).toHaveLength(2);
  });

  it("over the limit: 429 with Retry-After, nothing sent upstream", async () => {
    const up = fakeUpstream();
    const deps = makeDeps(up.fetch);
    const l = limiter(3);
    expect((await handle(post(100, 0), { FORECAST_LIMITER: l }, deps)).status).toBe(200);
    const res = await handle(post(100, 10), { FORECAST_LIMITER: l }, deps);
    expect(res.status).toBe(429);
    expect(res.headers.get("retry-after")).toBe("60");
    expect(await res.json()).toMatchObject({ error: true });
    expect(up.calls).toHaveLength(1);
    // Cached spots still come back for that IP.
    expect((await handle(post(100, 0), { FORECAST_LIMITER: l }, deps)).status).toBe(200);
  });

  it("one counter per IP, shared by forecast, marine and archive", async () => {
    const deps = makeDeps(fakeUpstream().fetch);
    const l = limiter(100);
    await handle(post(10, 0, "198.51.100.1"), { FORECAST_LIMITER: l }, deps);
    await handle(
      new Request(`${ORIGIN}/v1/marine?latitude=1&longitude=2&${MARINE_PARAMS}`, { headers: { "cf-connecting-ip": "198.51.100.2" } }),
      { FORECAST_LIMITER: l },
      deps,
    );
    expect(l.keys).toEqual(["forecast:198.51.100.1", "forecast:198.51.100.2"]);
  });

  it("a full cold search (400 spots in 4 batches, two cell groups, tides, model check) fits the limit", async () => {
    const deps = makeDeps(fakeUpstream().fetch);
    const l = limiter(100);
    const statuses: number[] = [];
    for (let b = 0; b < 4; b++) {
      statuses.push((await handle(post(100, b), { FORECAST_LIMITER: l }, deps)).status);
      statuses.push((await handle(post(100, b, "203.0.113.7", "/v1/forecast", LAND), { FORECAST_LIMITER: l }, deps)).status);
      statuses.push((await handle(post(100, b, "203.0.113.7", "/v1/marine", MARINE_PARAMS), { FORECAST_LIMITER: l }, deps)).status);
    }
    statuses.push((await handle(post(5, 10, "203.0.113.7", "/v1/forecast", SWIFT_CONFIDENCE), { FORECAST_LIMITER: l }, deps)).status);
    expect(new Set(statuses)).toEqual(new Set([200]));
    expect(l.keys.length).toBeLessThanOrEqual(40);
  });
});
