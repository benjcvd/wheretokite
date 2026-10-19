# WhereToKite API (Cloudflare Worker)

A small backend between the iOS app and Open-Meteo, plus the spot catalogue and an inbox for
anonymous feedback.

**Why it exists.** The app used to call Open-Meteo straight from each phone, one location per
spot per search. Mobile carriers put many phones behind one IP (CGNAT), so Open-Meteo's free
per-IP quota (600 calls/min, 10,000/day, where each location counts as one call) runs out
quickly once there are many users. A paid Open-Meteo key can't ship inside the app either.
Every user gets the same forecast, so the Worker keeps one shared cache. The number of
Open-Meteo calls then grows with the number of distinct spots, days and models, not with the
number of users.

## API

The base URL is wherever you deploy it, for example `https://wheretokite-api.<you>.workers.dev`
or `https://api.yourdomain.com`.

| Method | Path | What it does |
|---|---|---|
| GET, POST | `/v1/forecast` | Same as `api.open-meteo.com/v1/forecast` |
| GET, POST | `/v1/archive` | Same as `historical-forecast-api.open-meteo.com/v1/forecast` (what the models forecast for past days) |
| GET, POST | `/v1/marine` | Same as `marine-api.open-meteo.com/v1/marine` |
| GET | `/v1/catalog` | The spot catalogue (`Data/spots.json` on `main`), with ETag and 304 support |
| POST | `/v1/diagnostics`, `/v1/feedback`, `/v1/report` | Anonymous JSON (64 KB max), written to the logs. Returns 204 |
| GET | `/v1/health` | `{"ok":true}` |

### Forecast endpoints (`/v1/forecast`, `/v1/archive`, `/v1/marine`)

These take the same parameters and return the same JSON as Open-Meteo, so the app only swaps
the host. Parameters can be sent as a query string (GET) or as an
`application/x-www-form-urlencoded` body (POST). Several locations go in comma-separated
`latitude`/`longitude`. One location returns an object. Several return an array in request
order, and every element after the first has `location_id` set to its index, as Open-Meteo
does.

How the cache works:

1. The request is split into locations. Each location gets a cache key made of the endpoint,
   every other parameter (sorted, trimmed, repeated keys merged, `apikey` removed) and the
   coordinates rounded to 4 decimals (about 11 m). Per-location values of `timezone` and
   `elevation` are part of that location's key.
2. Each key is looked up in an in-memory LRU, which belongs to one Worker instance and is
   instant. On a miss it is then looked up in the Cloudflare Cache API, which is shared by
   every instance in a data centre.
3. Only the missing locations go to Open-Meteo, at most 100 locations per upstream request,
   with the requests sent in parallel. Each location's JSON is stored separately.
4. The response is put back together in the caller's order.

Each location stays cached for **1 hour** on forecast and marine, because Open-Meteo updates
as model runs arrive, some of them hourly. On archive it stays cached for **24 hours**.

Response headers:

- `X-Cache: HIT | MISS | PARTIAL`, plus `X-Cache-Hits: 3/4`.
- `Cache-Control: public, max-age=N`, where N is the time left before the oldest location in
  the response expires.

Limits and errors. Errors use Open-Meteo's shape, `{"error":true,"reason":"..."}`:

- 400: missing coordinates, non-numeric coordinates, out-of-range coordinates, more than 400
  locations, `elevation` count not matching the number of coordinates, or a `format` other
  than JSON.
- 404: unknown path. 405: wrong method. 413: POST body over 64 KB. 415: a POST body that is
  not form-encoded.
- Errors from Open-Meteo are passed through unchanged (status and body), and nothing is cached
  for them. If Open-Meteo can't be reached the Worker returns 502, and 504 after 25 s.

Upstream. When the secret `OPEN_METEO_API_KEY` is set, the Worker calls the customer endpoints
(`customer-api.open-meteo.com`, `customer-historical-forecast-api.open-meteo.com`,
`customer-marine-api.open-meteo.com`) with `apikey=`. Otherwise it calls the free endpoints.

### `GET /v1/catalog`

Fetches `CATALOG_URL`, which defaults to
`https://raw.githubusercontent.com/benjcvd/wheretokite/main/Data/spots.json`, and caches it
for 1 hour. The response carries `ETag` (part of the SHA-256 of the content). A request with
`If-None-Match: <etag>` gets `304 Not Modified` and no body.

To update the catalogue, push to `main`. Apps see the change within about an hour, with no
app release. If the fetched file is not valid JSON with a `spots` array, it is ignored and
the last good copy keeps being served, so a broken push can't break the app.

### Intake: `POST /v1/diagnostics`, `/v1/feedback`, `/v1/report`

- The body must be a JSON object or array of at most 64 KB. Otherwise you get 400 or 413.
- Each accepted request is logged as one line:
  `{"kind":"feedback","bytes":59,"country":"FR","payload":{...}}`. The response is 204.
- No IP address is logged.
- **Rate limit:** 20 requests per minute per IP per endpoint, through the
  [Rate Limiting binding](https://developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/)
  (`[[ratelimits]]` in `wrangler.toml`). Requests over the limit get 429. The IP is used only
  as the counter key. To turn the limit off, delete that block.

## Deploying (owner)

1. Create a free Cloudflare account at https://dash.cloudflare.com/sign-up.
2. Install Node.js LTS (https://nodejs.org). Then, in this folder:
   ```sh
   cd server
   npm install
   npx wrangler login          # opens the browser to authorize
   npx wrangler deploy         # prints https://wheretokite-api.<subdomain>.workers.dev
   curl https://wheretokite-api.<subdomain>.workers.dev/v1/health
   ```
3. Optional, for a paid Open-Meteo plan:
   ```sh
   npx wrangler secret put OPEN_METEO_API_KEY   # paste the key; it is stored encrypted, never in git
   ```
   To go back to the free endpoints, run `npx wrangler secret delete OPEN_METEO_API_KEY`.
4. **Custom domain, recommended for production.** Cloudflare documents the shared Cache API
   as working on custom domains. On a `*.workers.dev` address, don't count on the shared
   cache. Only the per-instance memory cache is certain to work there, which helps much less.
   - Add a domain to Cloudflare (any registrar; Cloudflare Registrar sells them at cost).
   - Uncomment the `routes` line in `wrangler.toml` with e.g. `api.yourdomain.com`, then run
     `npx wrangler deploy` again.
   - To check that the cache works, send the same request twice. The second response should
     have `X-Cache: HIT`.
5. Point the app's base URL at the Worker.

Checks:

- Run the tests with `npm test`.
- Run a local server with `npx wrangler dev`, then use `http://localhost:8787/v1/...`. It uses
  real Open-Meteo, and its cache is stored in `.wrangler/`.

## Costs

- **Workers Free:** 100,000 requests/day, 10 ms CPU per request. This Worker uses very little
  CPU. Cache API and Rate Limiting are included at no cost.
- **Workers Paid:** $5/month for 10 million requests/month, then $0.30 per extra million.
- **Open-Meteo** has two kinds of quota:
  - The free tier is for non-commercial use and limited per IP, and every Worker call comes
    from Cloudflare's IPs. That is fine for testing. In production, use an API key (plans:
    https://open-meteo.com/en/pricing).
  - With the cache, Open-Meteo calls ≈ distinct (spot × day × model × parameter set) per hour
    in each Cloudflare data centre. That number does not depend on the number of users. A
    catalogue of 300 spots searched for 3 days costs at most about 900 calls/hour per data
    centre, however many people search.

## Logs

- In the dashboard, go to **Workers & Pages → wheretokite-api → Logs**. Workers Logs is
  enabled in `wrangler.toml`. Filter on `kind` (`feedback`, `report`, `diagnostics`,
  `catalog_error`, `internal_error`).
- For a live stream, run `npx wrangler tail` (or `npm run logs`). Add `--format json` for
  output a script can read.
