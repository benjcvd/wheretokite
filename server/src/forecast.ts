// Open-Meteo proxy with a per-location shared cache.
//
// A request for N locations is split into N cache entries (one per location), so two users
// whose searches overlap on 290 of 300 spots share 290 entries. Only the missing locations
// go upstream, in as few multi-location requests as possible (<= UPSTREAM_CHUNK each), and
// the response is reassembled in the caller's order with exactly Open-Meteo's shape.

import { type Cache, type CachedEntry, apiError, ApiError, json, readLimited } from "./util";

export type Endpoint = "forecast" | "archive" | "marine";

interface EndpointConfig {
  free: string;
  customer: string;
  /** Seconds a location stays cached. */
  ttl: number;
}

export const ENDPOINTS: Record<Endpoint, EndpointConfig> = {
  // Open-Meteo refreshes its forecasts as model runs land (some every hour), so never keep
  // a forecast longer than an hour.
  forecast: {
    free: "https://api.open-meteo.com/v1/forecast",
    customer: "https://customer-api.open-meteo.com/v1/forecast",
    ttl: 3600,
  },
  marine: {
    free: "https://marine-api.open-meteo.com/v1/marine",
    customer: "https://customer-marine-api.open-meteo.com/v1/marine",
    ttl: 3600,
  },
  // What the models forecast for past days: doesn't change, a day is plenty.
  archive: {
    free: "https://historical-forecast-api.open-meteo.com/v1/forecast",
    customer: "https://customer-historical-forecast-api.open-meteo.com/v1/forecast",
    ttl: 86400,
  },
};

export const MAX_LOCATIONS = 400;
export const UPSTREAM_CHUNK = 100;
/** Bump to invalidate every cached location after a format change. */
const CACHE_VERSION = "1";

/** Parameters that carry one value per location (comma lists aligned with the coordinates). */
const PER_LOCATION = ["elevation", "timezone"] as const;
/** Never forwarded from the client: the key is the server's. */
const DROPPED = new Set(["apikey", "latitude", "longitude"]);

export interface Location {
  /** Rounded to 4 decimals, as sent upstream and used in the cache key. */
  lat: string;
  lon: string;
  /** Per-location parameters (elevation, timezone) for this location, sorted by name. */
  extra: [string, string][];
}

export interface ParsedRequest {
  endpoint: Endpoint;
  /** Parameters shared by all locations, normalized and sorted by name. */
  shared: [string, string][];
  locations: Location[];
}

const NUMBER = /^[+-]?(\d+(\.\d*)?|\.\d+)$/;

function round4(value: string, name: string, limit: number): string {
  if (!NUMBER.test(value)) throw new ApiError(400, `Parameter '${name}' must be a number, got '${value}'`);
  const n = Number(value);
  if (!Number.isFinite(n) || Math.abs(n) > limit) {
    throw new ApiError(400, `Parameter '${name}' must be between -${limit} and ${limit}, got '${value}'`);
  }
  const s = n.toFixed(4);
  return s === "-0.0000" ? "0.0000" : s;
}

function splitList(value: string): string[] {
  return value.split(",").map((v) => v.trim());
}

/**
 * Normalizes Open-Meteo parameters: repeated keys are merged into one comma list, list items
 * are trimmed, empty values dropped, keys sorted. List order is kept (it is the order of the
 * keys in the response).
 */
export function parseParams(params: URLSearchParams, endpoint: Endpoint): ParsedRequest {
  const merged = new Map<string, string[]>();
  for (const [rawKey, rawValue] of params) {
    const key = rawKey.trim();
    if (!key) continue;
    // Empty coordinates are kept so that "1,,2" is reported, not silently shifted.
    const coord = key === "latitude" || key === "longitude";
    const items = splitList(rawValue).filter((v) => coord || v !== "");
    if (items.length === 0) continue;
    merged.set(key, [...(merged.get(key) ?? []), ...items]);
  }

  const format = merged.get("format");
  if (format && !(format.length === 1 && format[0] === "json")) {
    throw new ApiError(400, "Only format=json is supported");
  }

  const lats = merged.get("latitude") ?? [];
  const lons = merged.get("longitude") ?? [];
  if (lats.length === 0 || lons.length === 0) {
    throw new ApiError(400, "Parameter 'latitude' and 'longitude' are required");
  }
  if (lats.length !== lons.length) {
    throw new ApiError(400, "Parameter 'latitude' and 'longitude' must have the same number of elements");
  }
  const n = lats.length;
  if (n > MAX_LOCATIONS) {
    throw new ApiError(400, `At most ${MAX_LOCATIONS} locations per request, got ${n}`);
  }

  const perLocation = new Map<string, string[]>();
  for (const name of PER_LOCATION) {
    const values = merged.get(name);
    if (!values) continue;
    if (values.length === n) perLocation.set(name, values);
    else if (values.length === 1 && name === "timezone") perLocation.set(name, Array(n).fill(values[0]));
    else throw new ApiError(400, `Parameter '${name}' must have the same number of elements as coordinates`);
  }

  const locations: Location[] = lats.map((lat, i) => ({
    lat: round4(lat, "latitude", 90),
    lon: round4(lons[i], "longitude", 180),
    extra: [...perLocation.entries()].map(([k, v]) => [k, v[i]] as [string, string]).sort(byKey),
  }));

  const shared = [...merged.entries()]
    .filter(([k]) => !DROPPED.has(k) && !perLocation.has(k) && k !== "format")
    .map(([k, v]) => [k, v.join(",")] as [string, string])
    .sort(byKey);

  return { endpoint, shared, locations };
}

function byKey(a: [string, string], b: [string, string]): number {
  return a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0;
}

/**
 * Synthetic URL under which one location's response is cached. It lives under the Worker's own
 * origin (the Cache API is per zone) in a path no route serves.
 */
export function cacheKey(origin: string, req: ParsedRequest, loc: Location): string {
  const q = new URLSearchParams(req.shared);
  for (const [k, v] of loc.extra) q.append(k, v);
  q.append("latitude", loc.lat);
  q.append("longitude", loc.lon);
  return `${origin}/__cache/v${CACHE_VERSION}/${req.endpoint}?${q.toString()}`;
}

export function chunk<T>(items: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < items.length; i += size) out.push(items.slice(i, i + size));
  return out;
}

/** Form body of one upstream multi-location request. */
export function upstreamBody(shared: [string, string][], locs: Location[], apiKey?: string): string {
  const q = new URLSearchParams(shared);
  q.set("latitude", locs.map((l) => l.lat).join(","));
  q.set("longitude", locs.map((l) => l.lon).join(","));
  for (const [name] of locs[0]?.extra ?? []) {
    q.set(name, locs.map((l) => l.extra.find(([k]) => k === name)![1]).join(","));
  }
  if (apiKey) q.set("apikey", apiKey);
  return q.toString();
}

/**
 * Splits an upstream response into one JSON string per location. `location_id` (Open-Meteo's
 * index within that upstream request) is removed: it is re-added for the caller's order.
 */
export function splitUpstream(body: unknown, expected: number): string[] {
  const items = expected === 1 && !Array.isArray(body) ? [body] : body;
  if (!Array.isArray(items) || items.length !== expected) {
    throw new ApiError(502, `Upstream returned ${Array.isArray(items) ? items.length : "no"} locations, expected ${expected}`);
  }
  return items.map((item) => {
    if (item === null || typeof item !== "object" || Array.isArray(item)) {
      throw new ApiError(502, "Upstream returned an unexpected location entry");
    }
    const { location_id: _ignored, ...rest } = item as Record<string, unknown>;
    return JSON.stringify(rest);
  });
}

/**
 * Open-Meteo's shape: one location -> the object; several -> an array where every element but
 * the first carries `location_id` = its index.
 */
export function reassemble(items: string[]): string {
  if (items.length === 1) return items[0];
  return `[${items
    .map((s, i) => {
      if (i === 0) return s;
      const o = JSON.parse(s) as Record<string, unknown>;
      o.location_id = i;
      return JSON.stringify(o);
    })
    .join(",")}]`;
}

export interface ForecastDeps {
  cache: Cache;
  fetch: typeof fetch;
  now: () => number;
  apiKey?: string;
  /** Background work that must outlive the response (ctx.waitUntil in the Worker). */
  waitUntil: (p: Promise<unknown>) => void;
  upstreamTimeoutMs?: number;
}

/** Reads GET query or POST form body (query string parameters are merged in). */
export async function readParams(request: Request, maxBytes: number): Promise<URLSearchParams> {
  const params = new URLSearchParams(new URL(request.url).search);
  if (request.method === "POST") {
    const type = request.headers.get("content-type") ?? "";
    if (type && !type.toLowerCase().startsWith("application/x-www-form-urlencoded")) {
      throw new ApiError(415, "POST body must be application/x-www-form-urlencoded");
    }
    const body = new TextDecoder().decode(await readLimited(request, maxBytes));
    for (const [k, v] of new URLSearchParams(body)) params.append(k, v);
  }
  return params;
}

export async function handleForecast(
  request: Request,
  endpoint: Endpoint,
  deps: ForecastDeps,
): Promise<Response> {
  const config = ENDPOINTS[endpoint];
  const parsed = parseParams(await readParams(request, 64 * 1024), endpoint);
  const origin = new URL(request.url).origin;
  const keys = parsed.locations.map((loc) => cacheKey(origin, parsed, loc));
  const now = deps.now();

  // 1. Cache lookups (all in parallel; identical locations in one request are looked up once).
  const unique = [...new Set(keys)];
  const found = new Map<string, CachedEntry>();
  await Promise.all(
    unique.map(async (key) => {
      const entry = await deps.cache.get(key);
      if (entry && now - entry.fetchedAt < config.ttl * 1000 && now >= entry.fetchedAt) found.set(key, entry);
    }),
  );

  // 2. Missing locations upstream, <= UPSTREAM_CHUNK per request, chunks in parallel.
  const missing = unique.filter((k) => !found.has(k));
  const missingLocs = missing.map((k) => parsed.locations[keys.indexOf(k)]);
  const chunks = chunk(missingLocs.map((loc, i) => ({ loc, key: missing[i] })), UPSTREAM_CHUNK);
  const results = await Promise.all(
    chunks.map((c) => fetchUpstream(config, parsed.shared, c.map((x) => x.loc), deps)),
  );
  const failed = results.find((r): r is Response => r instanceof Response);
  if (failed) return failed;
  chunks.forEach((c, ci) => {
    const bodies = results[ci] as string[];
    c.forEach(({ key }, i) => {
      const entry = { body: bodies[i], fetchedAt: now };
      found.set(key, entry);
      deps.waitUntil(deps.cache.put(key, entry, config.ttl));
    });
  });

  // 3. Reassemble in the caller's order.
  const items = keys.map((k) => found.get(k)!.body);
  const missed = new Set(missing);
  const hits = keys.filter((k) => !missed.has(k)).length;
  const oldest = Math.min(...keys.map((k) => found.get(k)!.fetchedAt));
  const maxAge = Math.max(0, Math.floor(config.ttl - (now - oldest) / 1000));
  return new Response(reassemble(items), {
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": `public, max-age=${maxAge}`,
      "X-Cache": hits === keys.length ? "HIT" : hits === 0 ? "MISS" : "PARTIAL",
      "X-Cache-Hits": `${hits}/${keys.length}`,
    },
  });
}

/** One upstream request: the per-location JSON strings, or an error Response to pass through. */
async function fetchUpstream(
  config: EndpointConfig,
  shared: [string, string][],
  locs: Location[],
  deps: ForecastDeps,
): Promise<string[] | Response> {
  const url = deps.apiKey ? config.customer : config.free;
  let res: Response;
  try {
    res = await deps.fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded", Accept: "application/json" },
      body: upstreamBody(shared, locs, deps.apiKey),
      signal: AbortSignal.timeout(deps.upstreamTimeoutMs ?? 25_000),
    });
  } catch (e) {
    const timeout = e instanceof Error && (e.name === "TimeoutError" || e.name === "AbortError");
    return apiError(timeout ? 504 : 502, timeout ? "Upstream timeout" : "Upstream unreachable");
  }
  const text = await res.text();
  if (!res.ok) {
    // Open-Meteo errors are {"error":true,"reason":...}: pass them through as they are.
    return new Response(text, {
      status: res.status,
      headers: {
        "Content-Type": res.headers.get("content-type") ?? "application/json; charset=utf-8",
        "Cache-Control": "no-store",
        "X-Cache": "MISS",
      },
    });
  }
  try {
    return splitUpstream(JSON.parse(text), locs.length);
  } catch (e) {
    if (e instanceof ApiError) return json({ error: true, reason: e.message }, e.status);
    return apiError(502, "Upstream returned invalid JSON");
  }
}
