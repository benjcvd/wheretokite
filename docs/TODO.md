# TODO

The single list of what's pending. Spot-by-spot questions live in `tools/spots/TO_CONFIRM.md`;
the full product review (with reasons) in `docs/BLIND_SPOTS.md`. Last updated 2026-10-20.

## Waiting on Ben
- [ ] Name and contact email for the privacy policy (GDPR "controller"): set `OPERATOR_NAME`
      and `CONTACT_EMAIL` in `server/wrangler.toml`, then redeploy.
- [ ] Spot decisions: Catalan spots (Nova Mar Bella, Torredembarra, La Pineda, Empuriabrava,
      L'Estartit, Malgrat); Garda (Campione vs Malcesine); inferred ban dates (Bolonia,
      Les Arbousiers, Gwithian); the rest of `tools/spots/TO_CONFIRM.md`.
- [ ] Buy a domain (~€10/yr) and add it to Cloudflare: the shared forecast cache needs it.
- [ ] Apple Developer Program (€99/yr), if not done yet.

## Before TestFlight
- [x] Version 1.0; `ITSAppUsesNonExemptEncryption = NO`. Build number: tick "Automatically
      manage version and build number" when uploading from Xcode.
- [x] Privacy policy and support pages: `/privacy`, `/support` on the server (need the contact above).
- [ ] App Privacy answers in App Store Connect, matching `/privacy`.
- [ ] App Store text and screenshots.
- [ ] Archive, upload, invite testers.

## Before public launch
- [ ] Connect the domain to the Worker (`routes` in `server/wrangler.toml`) and point
      `AppConfig.serverURL` at it.
- [ ] Open-Meteo paid plan (free tier: 10K calls/day, non-commercial) →
      `npx wrangler secret put OPEN_METEO_API_KEY`.
- [ ] Web-verified pass on the wave-2 countries (needs a fresh Claude session: web search limit).
- [ ] Refresh the `osm-cache` release after big catalogue changes.
- [ ] Los Lances pin sits on a bar ("Waves", 202 m from the shore): point `locate` at the beach
      (found by the first triage; direction is fine).

## Before Pro goes on sale
- [ ] StoreKit 2 subscription, restore purchases, Family Sharing, intro offer; `PlanStore.mode`
      → `.proForSale`.
- [ ] Decide accounts: plan is no accounts (Apple ID holds the purchase, iCloud syncs own
      spots, an anonymous install id for alerts); Sign in with Apple only if Android/web come.
- [ ] "It's on" alerts: push notifications from the server (needs the domain + APNs key).
- [ ] Reword or commit to the paywall promise "Everything you use today stays free".

## Backlog (from the blind-spots review)
- Community (long run, Ben likes it): shared spots, spot reviews, "who's riding here today".
  Needs identity → Sign in with Apple (+ Google if Android); Pro stays an App Store purchase.
- Home-screen widget.
- Foil / wing / board type shifts the kite range.
- Beginners: "I rent / take lessons", school flag per spot; structured spot info (hazards,
  parking, rules).
- Waves / swell, water and air temperature.
- Units (kn, km/h, m/s, Bft; kg/lb).
- Localisation: FR, DE, ES, NL.
- Remote config (plan mode, banners, minimum version).
- CI for the app (build + tests on each push); test gaps (confidence, recorded API fixtures,
  429s, DST days, plan clamping).
- Offline: keep the last result with "updated 3 h ago".
- Live wind stations / webcams, favourites, share card, rating prompt.
- Audio Graph for the wind chart (accessibility).

## Done recently
GitHub automation verified: catalogue build (seeded OSM cache, Apple check works on GitHub)
and report triage (test issue #1 checked and closed with sources). Server live (Cloudflare Worker, forecasts + catalogue + reports), app connected; reports →
GitHub issues → Claude triage → PR for review → catalogue rebuilt on merge; rain penalty;
"Report an issue" with categories (public-issue warning); next good window is Pro;
disclaimer, About, bans, storms, evening/custom hours, "How was it?", crash reports.
