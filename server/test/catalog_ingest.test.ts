import { beforeEach, describe, expect, it, vi } from "vitest";
import { etagMatches, resetCatalogState } from "../src/catalog";
import { handle, type Deps } from "../src/index";
import { MAX_INGEST_BYTES } from "../src/ingest";
import { MemoryCache } from "../src/util";

const ORIGIN = "https://api.test";
const CATALOG = JSON.stringify({ generatedAt: "x", spots: [{ id: "a" }] });

function makeDeps(fetchImpl: Deps["fetch"], now = () => 1_000_000_000_000): Deps {
  return { cache: new MemoryCache(100, now), fetch: fetchImpl, now, waitUntil: () => {} };
}

describe("catalog", () => {
  beforeEach(() => resetCatalogState());

  it("serves the catalogue with an ETag and answers If-None-Match with 304", async () => {
    const fetchImpl = vi.fn(async () => new Response(CATALOG));
    const deps = makeDeps(fetchImpl);
    const r1 = await handle(new Request(`${ORIGIN}/v1/catalog`), {}, deps);
    expect(r1.status).toBe(200);
    expect(await r1.text()).toBe(CATALOG);
    const etag = r1.headers.get("etag")!;
    expect(etag).toMatch(/^"[0-9a-f]{32}"$/);

    const r2 = await handle(new Request(`${ORIGIN}/v1/catalog`, { headers: { "If-None-Match": etag } }), {}, deps);
    expect(r2.status).toBe(304);
    expect(await r2.text()).toBe("");
    expect(r2.headers.get("etag")).toBe(etag);

    const r3 = await handle(new Request(`${ORIGIN}/v1/catalog`, { headers: { "If-None-Match": '"other"' } }), {}, deps);
    expect(r3.status).toBe(200);
    expect(fetchImpl).toHaveBeenCalledTimes(1); // cached for the hour
  });

  it("refetches after an hour, uses CATALOG_URL, and the ETag follows the content", async () => {
    let t = 1_000_000_000_000;
    let body = CATALOG;
    const fetchImpl = vi.fn(async (_url: string | URL | Request) => new Response(body));
    const deps = makeDeps(fetchImpl, () => t);
    const env = { CATALOG_URL: "https://example.com/spots.json" };
    const e1 = (await handle(new Request(`${ORIGIN}/v1/catalog`), env, deps)).headers.get("etag");
    body = JSON.stringify({ spots: [] });
    t += 3601_000;
    const e2 = (await handle(new Request(`${ORIGIN}/v1/catalog`), env, deps)).headers.get("etag");
    expect(fetchImpl.mock.calls[0][0]).toBe("https://example.com/spots.json");
    expect(e1).not.toBe(e2);
  });

  it("keeps serving the last good copy when the source breaks", async () => {
    let t = 1_000_000_000_000;
    let ok = true;
    const deps = makeDeps(vi.fn(async () => (ok ? new Response(CATALOG) : new Response("{broken"))), () => t);
    await handle(new Request(`${ORIGIN}/v1/catalog`), {}, deps);
    ok = false;
    t += 3601_000;
    const res = await handle(new Request(`${ORIGIN}/v1/catalog`), {}, deps);
    expect(res.status).toBe(200);
    expect(await res.text()).toBe(CATALOG);
  });

  it("502 when the source is unavailable and nothing is cached", async () => {
    const deps = makeDeps(vi.fn(async () => new Response("nope", { status: 404 })));
    expect((await handle(new Request(`${ORIGIN}/v1/catalog`), {}, deps)).status).toBe(502);
  });

  it("matches ETags weakly, in lists, and *", () => {
    expect(etagMatches('W/"abc"', '"abc"')).toBe(true);
    expect(etagMatches('"x", "abc"', '"abc"')).toBe(true);
    expect(etagMatches("*", '"abc"')).toBe(true);
    expect(etagMatches('"abd"', '"abc"')).toBe(false);
    expect(etagMatches(null, '"abc"')).toBe(false);
  });
});

describe("intake endpoints", () => {
  const deps = makeDeps(vi.fn());
  const post = (path: string, body: BodyInit, headers: Record<string, string> = {}) =>
    handle(new Request(`${ORIGIN}${path}`, { method: "POST", body, headers: { "Content-Type": "application/json", ...headers } }), {}, deps);

  it("accepts JSON, logs one compact line, returns 204", async () => {
    const log = vi.spyOn(console, "log").mockImplementation(() => {});
    const res = await post("/v1/feedback", JSON.stringify({ spotId: "a", day: "2026-10-19", score: 7, rating: 1 }));
    expect(res.status).toBe(204);
    expect(log).toHaveBeenCalledTimes(1);
    const line = JSON.parse(log.mock.calls[0][0] as string);
    expect(line).toMatchObject({ kind: "feedback", payload: { spotId: "a", rating: 1 } });
    log.mockRestore();
  });

  it("rejects invalid JSON and non-objects with 400", async () => {
    expect((await post("/v1/report", "{nope")).status).toBe(400);
    expect((await post("/v1/report", "42")).status).toBe(400);
  });

  it("rejects bodies over 64 KB with 413, whether declared or streamed", async () => {
    const big = JSON.stringify({ x: "a".repeat(MAX_INGEST_BYTES) });
    expect((await post("/v1/diagnostics", big)).status).toBe(413);
    // no Content-Length: a stream that turns out too big
    const stream = new ReadableStream({
      start(c) {
        for (let i = 0; i < 70; i++) c.enqueue(new TextEncoder().encode("a".repeat(1024)));
        c.close();
      },
    });
    const req = new Request(`${ORIGIN}/v1/diagnostics`, { method: "POST", body: stream, duplex: "half" } as RequestInit);
    expect((await handle(req, {}, deps)).status).toBe(413);
    // exactly at the limit is fine
    const ok = JSON.stringify({ x: "a".repeat(MAX_INGEST_BYTES - 10) });
    vi.spyOn(console, "log").mockImplementation(() => {});
    expect((await post("/v1/diagnostics", ok)).status).toBe(204);
  });

  it("405 for GET, 429 when the rate limiter says no", async () => {
    expect((await handle(new Request(`${ORIGIN}/v1/feedback`), {}, deps)).status).toBe(405);
    const env = { INGEST_LIMITER: { limit: async () => ({ success: false }) } };
    const res = await handle(new Request(`${ORIGIN}/v1/feedback`, { method: "POST", body: "{}" }), env, deps);
    expect(res.status).toBe(429);
  });
});
