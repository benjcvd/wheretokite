# Reply to App Review: Guideline 2.1, Information Needed (7 Nov 2026)

Apple is asking about the 25 Oct submission. Answer it with the new build (1.0 bdfd577), so the
review covers what you'll actually ship.

## Step by step

1. **Upload the new build.** Xcode → Window → Organizer → "WhereToKite 1.0 bdfd577" →
   Distribute App → App Store Connect → Upload (tick "Automatically manage version and build
   number"). Wait for the "processing complete" email (10–30 min).
2. **Check your iPhone runs the latest iOS** (Settings → General → Software Update). Apple
   requires it for the recording.
3. **Install the same build fresh on your iPhone**: delete WhereToKite from the phone, then
   in Xcode pick your iPhone as the destination and press Run (Cmd+R). A fresh install shows
   the first-launch screens, which the recording must include.
4. **Record the screen** (Control Centre → Screen Recording; if it's missing, add it via
   Settings → Control Centre). Follow the [recording script](#recording-script). Stop the
   recording, then AirDrop it to your Mac. Keep it under about 2 minutes.
5. **App Store Connect → Where To Kite → iOS App 1.0**:
   - Build section: remove the old build, pick the new one.
   - App Review Information → **Notes**: replace the text with [Notes for the reviewer](#notes-for-the-reviewer).
   - App Review Information → **Attachment**: upload the video.
   - Save.
6. **Reply to Apple**: App Store Connect → Where To Kite → App Review (or the link in the
   email) → open the message → Reply. Paste [Reply to Apple](#reply-to-apple) and attach the
   video again. Send.
7. **Resubmit**: back on version 1.0 → Add for Review → Submit for Review. Apple then
   reviews the new build with your answers, usually within 24–48 h.

## Recording script

1. Start on the iPhone home screen, tap the WhereToKite icon.
2. Accept the safety terms, fill in the rider profile (75 kg, intermediate, 9 m and 12 m).
3. Kite tab: tap the start point, type "Tarifa", choose it. Pick tomorrow, Afternoon.
4. Wait for the ranked list. Scroll a little, switch to Map, back to List.
5. Tap the top spot: show the wind chart, the forecast confidence and the Directions button.
6. Go back, open the spot's menu or the "Report an issue" screen, show the warning that
   reports are public, then cancel without sending.
7. Open the Me tab: profile, language, About / privacy links. Done.

No account, no purchase and nothing posted by other users to show, so nothing else is needed.

## Notes for the reviewer

Paste into App Review Information → Notes:

```
WhereToKite tells kitesurfers where to ride on a given day. The rider picks a start point, a maximum drive time, a day and a session (morning, afternoon, evening or custom hours). The app checks the wind forecast at every known kite spot in reach and returns a ranked list with a score, the best 2-hour window, how sure the forecast is, an hourly wind chart and driving directions.

No account, no login and no purchase: everything is free in version 1.0.

To test:
1. On first launch, accept the safety terms and fill in the rider profile (any values, e.g. 75 kg, intermediate, 9 m and 12 m kites).
2. On the Kite tab, tap the start point and type "Tarifa" (or use Current location if you are in Europe). Pick a day and a session.
3. The ranked list of spots updates by itself. Tap a spot to see the hourly wind chart and directions.

The spot catalogue covers Europe and Morocco only: a start point in the United States returns no spots, so please type a European town such as Tarifa or Barcelona.

Location is optional and only used as the start point.

"Report an issue" sends a short anonymous report about a spot (wrong position, missing rule...), published as an issue on our public GitHub repository; the app says so before sending. Reports are not shown to other users inside the app.

A screen recording on an iPhone with the latest iOS is attached.
```

## Reply to Apple

Paste into the reply, and attach the video:

```
Hello,

Thank you for the review. Here is the information requested; I have also added it to the App Review Information notes, and submitted a new build (1.0) that I tested on my own iPhone.

1. Screen recording
Attached: recorded on an iPhone running the latest iOS, starting from the app launch and showing the typical flow. The app has no account registration or login, no paid content or in-app purchase, and no user-generated content shown to other users.

2. Purpose and audience
WhereToKite is for kitesurfers in Europe and Morocco, from beginners to advanced riders. Every windy day they face the same problem: which spot within driving distance will actually have good, safe wind during the hours they can ride? Today they compare several weather sites spot by spot. WhereToKite does it in one search: from a start point, a maximum drive time, a day and a session, it ranks the spots in reach by how well the forecast wind suits the rider's weight, level and kites, shows the best 2-hour window and how sure the forecast is, and gives driving directions. Safety comes first: thunderstorms, darkness, offshore wind and official seasonal kite bans score zero.

3. How to use it
No login, credentials or sample files are needed.
- First launch: accept the safety terms and fill in the rider profile (e.g. 75 kg, intermediate, 9 m and 12 m kites).
- Kite tab: choose the start point (type "Tarifa" or "Barcelona", or use the current location in Europe), a maximum drive time, a day and a session.
- The ranked list appears; tap a spot for the hourly wind chart, the forecast confidence and directions.
- Me tab: edit the profile, the app language (English, French, Spanish), and read the About, privacy and support pages.

4. External services
- Open-Meteo (open-meteo.com): weather and tide forecasts, fetched through our own server.
- Cloudflare Workers: our server, which caches forecasts and serves the spot catalogue.
- Apple MapKit: maps, place search and driving times. Apple also provides crash reports.
- OpenStreetMap data (ODbL licence, credited in the app): positions of the kite spots.
- GitHub: receives the optional, anonymous "Report an issue" reports as public issues.
No login, payment, advertising, analytics or AI service is used.

5. Regional differences
The app works the same in every region and language. Its content, the catalogue of kite spots, covers Europe and Morocco only, so a start point elsewhere (for example in the United States) returns no spots. That is expected; the store description states the coverage.

6. Regulated industry or third-party material
Not applicable. The app is not in a regulated industry. Forecast data comes from Open-Meteo under its terms, with attribution; spot positions come from OpenStreetMap under the ODbL, with attribution.

Best regards,
Benjamin Chevignard
```
