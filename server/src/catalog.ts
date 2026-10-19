// Spot catalogue: proxied from the repo's Data/spots.json so that updating spots is a git push.

import { type Cache, type CachedEntry, apiError, sha256Hex } from "./util";

export const DEFAULT_CATALOG_URL = "https://raw.githubusercontent.com/benjcvd/wheretokite/main/Data/spots.json";
export const CATALOG_TTL = 3600;

export interface CatalogDeps {
  cache: Cache;
  fetch: typeof fetch;
  now: () => number;
  catalogUrl?: string;
  waitUntil: (p: Promise<unknown>) => void;
}

/** Last good copy per isolate: served if GitHub is down after the cached copy expired. */
let lastGood: CachedEntry | undefined;

export function resetCatalogState() {
  lastGood = undefined;
}

/** True when the If-None-Match header names this ETag (weak comparison, `*` matches). */
export function etagMatches(ifNoneMatch: string | null, etag: string): boolean {
  if (!ifNoneMatch) return false;
  const bare = (t: string) => t.trim().replace(/^W\//, "");
  return ifNoneMatch.split(",").some((t) => t.trim() === "*" || bare(t) === bare(etag));
}

export async function handleCatalog(request: Request, deps: CatalogDeps): Promise<Response> {
  const origin = new URL(request.url).origin;
  const key = `${origin}/__cache/v1/catalog`;
  const now = deps.now();

  let entry = await deps.cache.get(key);
  if (!entry || now - entry.fetchedAt >= CATALOG_TTL * 1000 || !entry.etag) {
    entry = (await fetchCatalog(deps, now)) ?? undefined;
    if (entry) deps.waitUntil(deps.cache.put(key, entry, CATALOG_TTL));
    else if (lastGood) entry = lastGood;
    else return apiError(502, "Catalogue unavailable");
  }
  lastGood = entry;

  const headers = {
    ETag: entry.etag!,
    // Clients revalidate cheaply with If-None-Match; 5 min keeps app launches snappy.
    "Cache-Control": "public, max-age=300",
  };
  if (etagMatches(request.headers.get("if-none-match"), entry.etag!)) {
    return new Response(null, { status: 304, headers });
  }
  return new Response(request.method === "HEAD" ? null : entry.body, {
    headers: { ...headers, "Content-Type": "application/json; charset=utf-8" },
  });
}

async function fetchCatalog(deps: CatalogDeps, now: number): Promise<CachedEntry | null> {
  try {
    const res = await deps.fetch(deps.catalogUrl || DEFAULT_CATALOG_URL, {
      signal: AbortSignal.timeout(15_000),
    });
    if (!res.ok) {
      console.log(JSON.stringify({ kind: "catalog_error", status: res.status }));
      return null;
    }
    const body = await res.text();
    // A broken push must not replace a good catalogue.
    const parsed = JSON.parse(body) as { spots?: unknown };
    if (!parsed || !Array.isArray(parsed.spots)) throw new Error("no spots array");
    return { body, fetchedAt: now, etag: `"${(await sha256Hex(body)).slice(0, 32)}"` };
  } catch (e) {
    console.log(JSON.stringify({ kind: "catalog_error", error: String(e) }));
    return null;
  }
}
