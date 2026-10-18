# Blind spots review (2026-10-18)

Read-only review of the app, the catalogue tooling and the plans. Severity H/M/L, effort S/M/L.

## Top priorities
1. **Open-Meteo licence + quota (H).** Free tier is non-commercial and limited per IP (10k calls/day,
   each location = 1 call; mobile carriers share IPs). Fix: a small proxy/cache in front of
   Open-Meteo (holds the commercial key, caches per spot/grid cell, shared by all users). Also
   needed for alerts. (M)
2. **No disclaimer / terms / About / support (H).** Add an accepted disclaimer in onboarding, a
   one-liner on the verdict, an About screen (terms, privacy, licences, version, contact). (S)
3. **Seasonal bans and unconfirmed directions don't affect scoring (H).** Structured `banned`
   periods per spot; never give the go card to `disagrees` spots. (S–M)
4. **No evening slot, no daylight cap (H).** Add "Evening" (17–21 h); clamp slots to
   sunrise/sunset. (S)
5. **"Pro coming soon" locks may be rejected by App Review (M–H).** Ship v1 without visible
   unpurchasable Pro UI (or `.allFree`), privacy policy URL ready. (S)

## Safety & legal
- Thunderstorms / squalls not modelled: fetch `weather_code`, `cape`, `precipitation`; storm hours
  score 0 (H, S).
- OSM ODbL share-alike: publish `spots.json` under ODbL and attribute in About + spot detail (H, S).
- Privacy policy naming Open-Meteo and Apple as recipients; App Privacy label to match (M, S).
- Wave-2 countries not web-verified: verify or label "beta" (M, M).

## Product
- "No wind" dead end: show "next good window" across 7 days even on free (H, M).
- Retention: home-screen widget; alerts need the proxy + push (H, M–L).
- Foil / wing / board type: shift the kite range for foils (M–H, S–M).
- Beginners without kites: "I rent / take lessons" + school flag per spot (M, M).
- Thin spot info: hazards, parking, rules, school as structured fields (M, M).
- Waves / swell (Marine API) for beginners and wave riders (M, M); water & air temperature (L–M, S).
- Forecast model choice / local effects (M, M).
- Units: kn / km/h / m/s / Bft; kg / lb (M, S).
- English only: String Catalog; FR, DE, ES, NL (M–H, M).
- Holidays: "on holiday? search your destination" hint; "outside covered area" message (L–M, S).

## Data & feedback
- No validation against real sessions: "How was it?" prompt, local log, opt-in upload (H, M).
- Catalogue only updates with app releases: versioned remote `spots.json` + bundled fallback (H, M).
- "Report a problem with this spot" button (M, S).
- Catalogue load uses `try?`: fail loudly, test decoding the shipped file (M, S).

## Engineering & operations
- Missing forecasts are silent ("no forecast" spots just vanish): tell the user; fetch 7 days per
  call; proxy cache (H, M).
- No crash reporting / analytics: MetricKit, `os.Logger`, privacy-friendly analytics (H, S–M).
- No remote config (plan mode, rules, banners, min version) (M, S).
- No CI / release pipeline; version hard-coded (M, M).
- Test gaps: ConfidenceEstimator, recorded API fixtures, 429 / partial failures, DST days, Plan
  clamping; UI tests depend on live forecasts (M, M).
- Searches re-run often (each option change, day change empties cache) (M, S).
- Offline: keep last result with "updated 3 h ago" (L–M, S).
- Catalogue decoded on the main actor at launch (L, S).

## Business
- StoreKit 2, restore purchases, Family Sharing, intro offer; alerts need a backend (H before Pro, M–L).
- Paywall promise "Everything you use today stays free" is a commitment: reword or decide
  grandfathering (M, S).
- Riders expect live station data / webcams, model comparison, favourites (M, S→M).
- Sharing (ShareLink card), rating prompt, localised store listings (M, S–M).
- Accessibility: Audio Graph for the wind chart (L, S).
