# TestFlight upload: Barcelona testers build (WHE-70)

The archive is ready: version 1.0, built from `main` on 2 Nov (07a08af), 630 spots, side-offshore
setting included. Xcode lists it in the Organizer as **WhereToKite 03-11-2026 WHE-70**.

## 1. Upload (5 min)

1. Xcode → **Window → Organizer** → **Archives** tab → select **WhereToKite**, then the
   archive dated 3 Nov (WHE-70).
2. **Distribute App** → **App Store Connect** → **Upload** (or **TestFlight & App Store**).
3. Keep **Automatically manage signing** and tick **Automatically manage version and build
   number** (it bumps the build number above the last upload).
4. **Upload**. Wait for "Upload succeeded".

## 2. Wait for processing (10–30 min)

Apple emails "has completed processing". The build then shows in
[App Store Connect](https://appstoreconnect.apple.com) → WhereToKite → **TestFlight**.
If it asks about export compliance: the app already declares no non-exempt encryption.

## 3. Give it to the testers

- **Internal testers** (people on your App Store Connect team): TestFlight → Internal Testing →
  your group → add the build. Available immediately.
- **External testers** (the Barcelona riders, by email or public link): TestFlight → External
  Testing → your group (create "Barcelona" if needed) → **+** build → fill "What to test" →
  **Submit for Review**. Beta review usually takes under 24 h for a first build, often
  minutes for the next ones. Then share the public link or add their emails.

## What to test (paste into TestFlight)

```
New in this build:
- Clearer verdict on each spot: Go, Worth a try, Coin flip, Long shot, No go. Spots are ranked by verdict first.
- Forecast now blends Météo-France, ECMWF and GFS depending on how many days ahead you look.
- Side-offshore spots: hidden for beginners and intermediates; advanced riders can opt in (Me tab) and see a warning.
- Updated spots around Barcelona and Catalonia (summer bans, Badalona, Torredembarra).

Please check: does the top spot match where you would actually go? Use "Report an issue" on any spot that looks wrong.
```

## If something fails

- **Signing error**: Xcode → Settings → Accounts, check you're signed in with the developer
  account (team YMM4B4C582), then retry.
- **"Redundant binary" / build number already used**: you skipped "Automatically manage version
  and build number"; retry with it ticked.
- **Archive missing from Organizer**: it's also at `/tmp/wtk-whe70/WhereToKite.xcarchive`
  (double-click it), or rebuild with Product → Archive on "Any iOS Device (arm64)".
