// WhereToKite API (Cloudflare Worker). See ../README.md.

import { handleCatalog } from "./catalog";
import { type Endpoint, handleForecast } from "./forecast";
import { handleIngest, type IngestKind } from "./ingest";
import { ApiError, apiError, type Cache, json, TieredCache } from "./util";

export interface Env {
  /** Paid Open-Meteo key (secret). Unset = free endpoints. */
  OPEN_METEO_API_KEY?: string;
  /** Override the spot catalogue source. */
  CATALOG_URL?: string;
  /** Optional Rate Limiting binding for the POST intake endpoints. */
  INGEST_LIMITER?: { limit(options: { key: string }): Promise<{ success: boolean }> };
}

export interface Deps {
  cache: Cache;
  fetch: typeof fetch;
  now: () => number;
  waitUntil: (p: Promise<unknown>) => void;
}

const FORECAST_ROUTES: Record<string, Endpoint> = {
  "/v1/forecast": "forecast",
  "/v1/archive": "archive",
  "/v1/marine": "marine",
};

const INGEST_ROUTES: Record<string, IngestKind> = {
  "/v1/diagnostics": "diagnostics",
  "/v1/feedback": "feedback",
  "/v1/report": "report",
};

function methodNotAllowed(allow: string): Response {
  const res = apiError(405, "Method not allowed");
  res.headers.set("Allow", allow);
  return res;
}

export async function handle(request: Request, env: Env, deps: Deps): Promise<Response> {
  const path = new URL(request.url).pathname.replace(/\/+$/, "") || "/";
  try {
    const endpoint = FORECAST_ROUTES[path];
    if (endpoint) {
      if (request.method !== "GET" && request.method !== "POST") return methodNotAllowed("GET, POST");
      return await handleForecast(request, endpoint, { ...deps, apiKey: env.OPEN_METEO_API_KEY || undefined });
    }
    const kind = INGEST_ROUTES[path];
    if (kind) {
      if (request.method !== "POST") return methodNotAllowed("POST");
      if (env.INGEST_LIMITER) {
        // The IP is only the rate-limit key: it is never logged or stored.
        const ip = request.headers.get("cf-connecting-ip") ?? "unknown";
        const { success } = await env.INGEST_LIMITER.limit({ key: `${kind}:${ip}` });
        if (!success) return apiError(429, "Too many requests");
      }
      return await handleIngest(request, kind);
    }
    if (path === "/v1/catalog") {
      if (request.method !== "GET" && request.method !== "HEAD") return methodNotAllowed("GET, HEAD");
      return await handleCatalog(request, { ...deps, catalogUrl: env.CATALOG_URL });
    }
    if (path === "/v1/health") return json({ ok: true }, 200, { "Cache-Control": "no-store" });
    return apiError(404, `Unknown endpoint ${path}`);
  } catch (e) {
    if (e instanceof ApiError) return apiError(e.status, e.message);
    console.error(JSON.stringify({ kind: "internal_error", path, error: String(e) }));
    return apiError(500, "Internal error");
  }
}

// One per isolate, so the in-memory tier is shared by all requests the isolate serves.
let cache: TieredCache | undefined;

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    cache ??= new TieredCache(caches.default);
    return handle(request, env, {
      cache,
      fetch: (input, init) => fetch(input, init),
      now: Date.now,
      waitUntil: (p) => ctx.waitUntil(p.catch((e) => console.error(JSON.stringify({ kind: "cache_put_error", error: String(e) })))),
    });
  },
} satisfies ExportedHandler<Env>;
