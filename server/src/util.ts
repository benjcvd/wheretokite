export class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
  ) {
    super(message);
  }
}

export function json(body: unknown, status = 200, headers: Record<string, string> = {}): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json; charset=utf-8", ...headers },
  });
}

/** Open-Meteo's error shape. */
export function apiError(status: number, reason: string): Response {
  return json({ error: true, reason }, status, { "Cache-Control": "no-store" });
}

/** Reads a request body, refusing (413) anything over `maxBytes` without buffering it all. */
export async function readLimited(request: Request, maxBytes: number): Promise<Uint8Array> {
  const declared = Number(request.headers.get("content-length") ?? "NaN");
  if (Number.isFinite(declared) && declared > maxBytes) {
    throw new ApiError(413, `Body larger than ${maxBytes} bytes`);
  }
  if (!request.body) return new Uint8Array();
  const reader = request.body.getReader();
  const parts: Uint8Array[] = [];
  let size = 0;
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    size += value.byteLength;
    if (size > maxBytes) {
      await reader.cancel().catch(() => {});
      throw new ApiError(413, `Body larger than ${maxBytes} bytes`);
    }
    parts.push(value);
  }
  const out = new Uint8Array(size);
  let offset = 0;
  for (const p of parts) {
    out.set(p, offset);
    offset += p.byteLength;
  }
  return out;
}

export interface CachedEntry {
  body: string;
  /** Epoch milliseconds. */
  fetchedAt: number;
  etag?: string;
}

/** Key-value cache of response bodies (keys are URLs). */
export interface Cache {
  get(key: string): Promise<CachedEntry | undefined>;
  put(key: string, entry: CachedEntry, ttlSeconds: number): Promise<void>;
}

/**
 * Two tiers: a small in-memory LRU per Worker instance (free, instant, but per isolate and lost
 * on eviction) in front of the Cloudflare Cache API (shared by every instance in a data centre).
 *
 * Note: the Cache API only works on a custom domain; on *.workers.dev it is a no-op, which
 * leaves only the in-memory tier.
 */
export class TieredCache implements Cache {
  private memory = new Map<string, CachedEntry & { expiresAt: number }>();

  constructor(
    private edge: globalThis.Cache | undefined,
    private maxEntries = 4000,
    private now: () => number = Date.now,
  ) {}

  async get(key: string): Promise<CachedEntry | undefined> {
    const m = this.memory.get(key);
    if (m) {
      this.memory.delete(key);
      if (m.expiresAt > this.now()) {
        this.memory.set(key, m); // most recently used goes last
        return m;
      }
    }
    if (!this.edge) return undefined;
    const res = await this.edge.match(new Request(key));
    if (!res) return undefined;
    const fetchedAt = Number(res.headers.get("x-fetched-at"));
    const ttl = Number(res.headers.get("x-ttl"));
    const entry: CachedEntry = {
      body: await res.text(),
      fetchedAt: Number.isFinite(fetchedAt) ? fetchedAt : 0,
      etag: res.headers.get("etag") ?? undefined,
    };
    if (Number.isFinite(ttl)) this.remember(key, entry, ttl);
    return entry;
  }

  async put(key: string, entry: CachedEntry, ttlSeconds: number): Promise<void> {
    this.remember(key, entry, ttlSeconds);
    if (!this.edge) return;
    const headers: Record<string, string> = {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": `public, max-age=${ttlSeconds}`,
      "X-Fetched-At": String(entry.fetchedAt),
      "X-Ttl": String(ttlSeconds),
    };
    if (entry.etag) headers.ETag = entry.etag;
    await this.edge.put(new Request(key), new Response(entry.body, { headers }));
  }

  private remember(key: string, entry: CachedEntry, ttlSeconds: number) {
    this.memory.delete(key);
    this.memory.set(key, { ...entry, expiresAt: entry.fetchedAt + ttlSeconds * 1000 });
    while (this.memory.size > this.maxEntries) {
      this.memory.delete(this.memory.keys().next().value!);
    }
  }
}

/** In-memory only (tests, or when no edge cache exists). */
export class MemoryCache extends TieredCache {
  constructor(maxEntries = 4000, now: () => number = Date.now) {
    super(undefined, maxEntries, now);
  }
}

export async function sha256Hex(text: string): Promise<string> {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}
