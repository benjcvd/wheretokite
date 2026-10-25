---
name: deploy-worker
description: Prepare, deploy and verify the live WhereToKite Cloudflare Worker (server/). Use for any server change, a new var or secret (OPERATOR_NAME, CONTACT_EMAIL, OPEN_METEO_API_KEY), or the custom domain. The deploy itself runs only after Ben's explicit OK.
---

# Deploying the Worker

The Worker is live: every app search goes through it. Prepare everything, then ask Ben, and
deploy only after his OK.

## 1. Before

```sh
cd server && npm test && npm run typecheck
```

If the forecast path changed, test it at real size against a local server: `npx wrangler dev`
in one shell, then a request with 100 spots from the catalogue:

```sh
python3 - <<'EOF' > /tmp/body.txt
import json
s = json.load(open("Data/spots.json"))["spots"][:100]
print("latitude=" + ",".join(f"{x['latitude']:.4f}" for x in s)
      + "&longitude=" + ",".join(f"{x['longitude']:.4f}" for x in s)
      + "&hourly=wind_speed_10m,wind_gusts_10m,wind_direction_10m&forecast_days=2&wind_speed_unit=kn")
EOF
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" -D - -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" --data @/tmp/body.txt \
  http://localhost:8787/v1/forecast | grep -iE "^(HTTP|x-cache)"
```

Expect 200, then `X-Cache: HIT` when sent a second time. The free Workers plan allows 50
subrequests per request: a 2-spot test once hid that limit.

## 2. Deploy (after Ben's OK)

```sh
cd server && PATH=~/.local/node/bin:$PATH npx wrangler deploy
```

- Vars (`OPERATOR_NAME`, `CONTACT_EMAIL`, `CATALOG_URL`) go in `[vars]` in `wrangler.toml`
  and are committed. Never put Ben's email anywhere else.
- Secrets: `npx wrangler secret put OPEN_METEO_API_KEY` (Ben pastes the value). Never in git,
  never in logs.
- Custom domain: uncomment `routes` in `wrangler.toml`, deploy, then point
  `AppConfig.serverURL` at it (an app change, so it ships with the next build).

## 3. After

```sh
BASE=https://wheretokite-api.wheretokite-api.workers.dev
curl -s $BASE/v1/health                              # {"ok":true}
curl -s -o /dev/null -w "%{http_code}\n" $BASE/privacy   # 200; check the name and email
curl -sI $BASE/v1/catalog | grep -i etag
```

Repeat the 100-spot request against `$BASE`. Then do one real search in the app.

**Rollback** if anything is off: `npx wrangler rollback` (back to the previous version), then
tell Ben what broke.
