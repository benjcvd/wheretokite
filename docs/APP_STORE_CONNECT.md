# App Store Connect: what to enter for v1

Everything to fill in for WhereToKite 1.0, in the order App Store Connect asks for it. Text in
code blocks is ready to paste. Last updated 2026-10-23.

Server base URL used below: `https://wheretokite-api.wheretokite-api.workers.dev` (replace it
everywhere once the custom domain is live).

## 0. Before you start

| What | Status | Where |
|---|---|---|
| Apple Developer Program (€99/yr) | done? | developer.apple.com |
| Name + contact email on `/privacy` and `/support` (GDPR) | **missing** | give them to Claude: `OPERATOR_NAME`, `CONTACT_EMAIL` in `server/wrangler.toml`, then redeploy |
| EU trader status (Digital Services Act) | **to decide** | App Store Connect → Business. See below |
| `main` pushed (Morocco fix in the bundled catalogue) | **waiting** | say "push" |
| Agreements, tax, banking | not needed for a free app | Business → Agreements: accept the Free Apps agreement |

**EU trader status.** Required to be distributed in the 27 EU countries. Declaring yourself a
trader means your address, phone number and email are shown publicly on the store page.
Declaring yourself a non-trader is allowed if the app isn't a commercial activity, which is
true for a free v1 without purchases or ads. You'll have to switch to trader when Pro goes on
sale. Your call.

## 1. Create the app (Apps → +)

| Field | Value |
|---|---|
| Platform | iOS |
| Name | `WhereToKite` |
| Primary language | English (U.K.). The app UI is English; Europe is the market |
| Bundle ID | `com.benjcvd.wheretokite` (register it first under Certificates, IDs & Profiles if it isn't listed; Xcode's automatic signing usually did it) |
| SKU | `wheretokite-ios` (internal, anything unique) |
| User access | Full access |

## 2. App information

| Field | Value |
|---|---|
| Subtitle (30 max) | `Best kite spot for your day` |
| Category | Primary: **Sports**. Secondary: **Weather** |
| Privacy policy URL | `https://wheretokite-api.wheretokite-api.workers.dev/privacy` |
| Support URL | `https://wheretokite-api.wheretokite-api.workers.dev/support` |
| Marketing URL | leave empty |
| Copyright | `2026 Benjamin Chevignard` (or your company name) |
| Content rights | "Yes, it contains third-party content, and I have the rights": weather from Open-Meteo (CC BY 4.0) and spots from OpenStreetMap (ODbL), both credited in the app |

## 3. Store listing (version 1.0)

**Promotional text** (170 max, can be changed anytime without review):

```
Tell it where you start, how far you'll drive and when you ride. WhereToKite checks the wind at every famous kite spot in reach and tells you where to go.
```

**Description** (4,000 max):

```
Where should you kite today? WhereToKite answers in one search.

Set your start point, how long you're willing to drive, the day and your session (morning, afternoon, evening or your own hours). WhereToKite checks the forecast at every well-known kite spot in reach and gives you a ranked list, with the best two-hour window at each spot. Up to three hours' drive and two days ahead.

MATCHED TO YOU AND YOUR KITES
Enter your weight, your level and the kites in your quiver once. Each hour is scored on what matters on the water:
• Wind strength: does it fit one of your kites, for a chill or an intense session?
• Steady wind: gusts compared with the mean wind.
• Direction: the wind against the way each beach faces. Side-onshore is best, offshore scores zero.

THE SPOTS
More than 600 famous kitesurf spots across Europe and Morocco, from Tarifa to Sylt and from Leucate to Dakhla. Each beach's direction is measured from map data and checked, so onshore, side-shore and offshore are told apart. Spots that only work at a certain tide get the tide forecast. Seasonal bans and summer bathing zones are taken into account.

SAFETY FIRST
Thunderstorms, darkness and banned hours score zero. A confidence rating tells you how far the weather models agree for your day.

ALSO
• Real drive times from Apple Maps.
• An hourly wind and gust chart for every spot, and directions in one tap.
• Add your own secret spot: it gets ranked like the others.
• Something wrong about a spot? Report it from the app; fixes reach everyone without an update.

NO ACCOUNT, NO TRACKING
Your profile and your own spots stay on your phone. No ads.

Scores are estimates from weather forecasts, not safety advice. Always check the conditions and local rules on site, and ride at your own risk.

Weather data by Open-Meteo.com. Spots © OpenStreetMap contributors.
```

**Keywords** (100 max, commas, no spaces after commas; don't repeat words from the name):

```
kitesurf,kitesurfing,kiteboarding,wind,forecast,spot,beach,tide,gusts,knots,weather,flat water
```

Don't name competitors (Windy, Windguru…) in keywords or text: App Review rejects it.

**What's new**: not shown for a first version.

## 3b. Store listing in Spanish

The app is in English and Spanish, so the store page can be too. Add the language once:

1. **App Information** (left column) → language menu at the top right (it shows
   "English (U.S.)") → **Add language** → **Spanish (Spain)**. Coverage is Europe and
   Morocco, so Spain is enough: no need for Spanish (Mexico).
2. Still in Spanish (Spain), fill in **Name** `WhereToKite` and **Subtitle** below, then **Save**.
3. **iOS App → 1.0 Prepare for Submission** → the same language menu → **Spanish (Spain)** →
   paste the promotional text, description and keywords below, then **Save**.
4. Screenshots: if you leave them empty, the English ones show. Spanish ones come from the
   `store-screenshots` skill with the simulator in Spanish.

Same URLs (privacy, support) as in English: they're shared by every language.

| Field | Value |
|---|---|
| Subtitle (30 max) | `El mejor spot de kite del día` |

**Promotional text**:

```
Dinos desde dónde sales, cuánto quieres conducir y cuándo navegas. WhereToKite mira el viento en cada spot de kite conocido a tu alcance y te dice adónde ir.
```

**Description**:

```
¿Dónde navego hoy? WhereToKite te lo dice en una sola búsqueda.

Elige tu punto de salida, cuánto estás dispuesto a conducir, el día y tu sesión (temprano, tarde, atardecer o tus propias horas). WhereToKite consulta la previsión en cada spot de kite conocido a tu alcance y te da una lista ordenada, con la mejor ventana de dos horas en cada spot. Hasta tres horas de trayecto y dos días vista.

ADAPTADO A TI Y A TUS COMETAS
Indica una vez tu peso, tu nivel y las cometas que tienes. Cada hora se puntúa según lo que importa en el agua:
• Fuerza del viento: ¿encaja con alguna de tus cometas, para una sesión tranquila o intensa?
• Viento estable: las rachas comparadas con el viento medio.
• Dirección: el viento frente a la orientación de cada playa. El side-onshore es lo mejor; el offshore puntúa cero.

LOS SPOTS
Más de 600 spots de kitesurf famosos en Europa y Marruecos, de Tarifa a Sylt y de Leucate a Dakhla. La orientación de cada playa se mide a partir de datos de mapas y se comprueba, para distinguir onshore, side-shore y offshore. Los spots que solo funcionan con cierta marea tienen la previsión de mareas. Se tienen en cuenta las prohibiciones de temporada y las zonas de baño de verano.

LA SEGURIDAD PRIMERO
Las tormentas, la noche y las horas prohibidas puntúan cero. Un indicador de fiabilidad te dice cuánto coinciden los modelos meteorológicos para tu día.

ADEMÁS
• Tiempos de trayecto reales de Apple Maps.
• Un gráfico de viento y rachas hora a hora para cada spot, y cómo llegar en un toque.
• Añade tu spot secreto: se clasifica igual que los demás.
• ¿Algo mal en un spot? Avísalo desde la app; las correcciones llegan a todos sin actualizar.

SIN CUENTA, SIN RASTREO
Tu perfil y tus spots se quedan en tu teléfono. Sin anuncios.

Las puntuaciones son estimaciones a partir de previsiones meteorológicas, no consejos de seguridad. Comprueba siempre las condiciones y las normas locales en el spot, y navega bajo tu propia responsabilidad.

Datos meteorológicos de Open-Meteo.com. Spots © colaboradores de OpenStreetMap.
```

**Keywords**:

```
kitesurf,kite,viento,previsión,playa,marea,rachas,nudos,tiempo,agua plana,cometa,terral,levante
```

## 3c. Store listing in French

Same steps as [Spanish](#3b-store-listing-in-spanish), with **French (France)** as the
language. It also covers Belgium, Switzerland and Morocco, so no French (Canada) needed.

| Field | Value |
|---|---|
| Subtitle (30 max) | `Le bon spot de kite du jour` |

**Promotional text**:

```
Dis d'où tu pars, jusqu'où tu roules et quand tu navigues. WhereToKite regarde le vent sur chaque spot de kite connu à ta portée et te dit où aller.
```

**Description**:

```
On ride où aujourd'hui ? WhereToKite te répond en une seule recherche.

Choisis ton point de départ, le temps de route que tu acceptes, le jour et ta session (matin, après-midi, soir ou tes propres heures). WhereToKite consulte la prévision sur chaque spot de kite connu à ta portée et te donne un classement, avec le meilleur créneau de deux heures sur chaque spot. Jusqu'à trois heures de route et deux jours à l'avance.

ADAPTÉ À TOI ET À TES AILES
Indique une fois ton poids, ton niveau et les ailes de ton quiver. Chaque heure est notée sur ce qui compte sur l'eau :
• Force du vent : convient-elle à une de tes ailes, pour une session tranquille ou engagée ?
• Vent régulier : les rafales comparées au vent moyen.
• Direction : le vent face à l'orientation de chaque plage. Le side-on est idéal, l'offshore vaut zéro.

LES SPOTS
Plus de 600 spots de kitesurf réputés en Europe et au Maroc, de Tarifa à Sylt et de Leucate à Dakhla. L'orientation de chaque plage est mesurée à partir de données cartographiques et vérifiée, pour distinguer onshore, side-shore et offshore. Les spots qui ne marchent qu'à une certaine marée ont la prévision des marées. Les interdictions saisonnières et les zones de baignade d'été sont prises en compte.

LA SÉCURITÉ D'ABORD
Les orages, la nuit et les heures interdites valent zéro. Un indice de confiance te dit à quel point les modèles météo s'accordent pour ton jour.

AUSSI
• De vrais temps de trajet avec Apple Plans.
• Un graphique du vent et des rafales heure par heure pour chaque spot, et l'itinéraire en un geste.
• Ajoute ton spot secret : il est classé comme les autres.
• Une erreur sur un spot ? Signale-la depuis l'app ; les corrections arrivent chez tout le monde sans mise à jour.

PAS DE COMPTE, PAS DE PISTAGE
Ton profil et tes spots restent sur ton téléphone. Pas de pub.

Les notes sont des estimations à partir de prévisions météo, pas des conseils de sécurité. Vérifie toujours les conditions et les règles locales sur place, et navigue à tes risques.

Données météo Open-Meteo.com. Spots © contributeurs OpenStreetMap.
```

**Keywords**:

```
kitesurf,kite,vent,prévision,météo,plage,marée,rafales,nœuds,aile,eau plate,glisse,kiteboard
```

## 4. Screenshots

- iPhone only (the app is iPhone-only): **6.9" display, 1320 × 2868 px** (iPhone 16 Pro Max /
  17 Pro Max simulator). Apple scales them down for smaller iPhones. 3 to 10 images.
- Suggested set, from a real search (Tarifa or Leucate, a windy day):
  1. Results list: ranked spots with scores and drive times.
  2. Spot detail: map and the hourly wind / gust chart.
  3. "Why this score": the three marks (strength, steady wind, direction).
  4. Search: start point, drive time, day, session.
  5. Profile: weight, level, quiver with each kite's wind range.
- Claude can generate them from the simulator (card `tf-store-text`), with an optional
  one-line caption on top of each.

## 5. App Privacy

**Privacy policy URL**: as above. Then "Do you or your third-party partners collect data from
this app?" → **Yes**. Declare exactly these data types, and for each one answer: **not linked
to the user's identity**, **not used for tracking**.

| Data type (Apple's name) | Purpose | What it is in the app |
|---|---|---|
| Location → **Coarse Location** | App Functionality | Rough area of the start point (about 10 km) and spot positions, sent to the server for forecasts (or to Open-Meteo directly when the server can't be reached) |
| Usage Data → **Product Interaction** | Analytics | "How was it?" answers (spot, day, score, rating) |
| Diagnostics → **Crash Data** | App Functionality | iOS MetricKit crash reports |
| Diagnostics → **Performance Data** | App Functionality | MetricKit hang and resource reports |
| User Content → **Other User Content** | App Functionality | "Report an issue" text, published as a GitHub issue |

Not collected: contact info, health, financial info, precise location (the start point goes
from the phone to Apple Maps directly, which is Apple's own service), identifiers, purchases,
contacts, browsing or search history, sensitive info.

These match `App/WhereToKite/PrivacyInfo.xcprivacy` and the `/privacy` page. If one of them
changes, update all three.

## 6. Age rating, encryption

**Age rating questionnaire**: answer **None / No** everywhere: no violence, no sexual content,
no profanity, no drugs, no gambling, no contests, no horror, no medical content. "Unrestricted
web access": **No**. "User-generated content shown to other users in the app": **No** (reports
go to GitHub and are not shown in the app). Expected result: **4+**.

**Export compliance**: already answered in the build (`ITSAppUsesNonExemptEncryption = NO`,
HTTPS only), so App Store Connect won't ask.

## 7. Pricing and availability

| Field | Value |
|---|---|
| Price | **Free** (USD 0, tier 0) |
| In-app purchases | none in v1 (Pro is hidden: `PaywallMode.freeOnly`) |
| Availability | Recommended: the countries the catalogue covers, i.e. the EU + United Kingdom, Switzerland, Norway, Montenegro, Morocco. Elsewhere the app finds no spots, which brings 1-star reviews |
| Pre-order | No |
| Distribution | Public (App Store) |

## 8. App Review information

| Field | Value |
|---|---|
| Sign-in required | **No** (no account in the app) |
| Contact | your first name, last name, phone, email (private, only for Apple) |
| Attachment | none |

**Notes for the reviewer** (paste):

```
WhereToKite ranks kite spots within driving distance for a chosen day and session. No account or purchase is needed.

To test:
1. On first launch, accept the safety terms and fill in the rider profile (any values, e.g. 75 kg, intermediate, 9 m and 12 m kites).
2. On the Kite tab ("Where to kite?"), tap the start point and type "Tarifa" (or use Current location if you are in Europe). Pick a day and a session.
3. The ranked list of spots updates by itself. Tap a spot to see the hourly wind chart and directions.

Location is used only as the start point and is optional: any town can be typed instead. The catalogue covers Europe and Morocco only, so a start point in the United States returns no spots.

"Report an issue" sends a short anonymous report that is published as an issue on our public GitHub repository; the app says so before sending. Weather data comes from Open-Meteo through our server (directly from Open-Meteo if our server can't be reached).
```

## 9. Build and submission, in order

1. Push `main`, wait for the catalogue build on GitHub (the bundled `Data/spots.json` then
   has the Morocco fix).
2. Xcode: scheme WhereToKite, destination "Any iOS Device (arm64)" → **Product → Archive**.
3. Organizer → **Distribute App → App Store Connect → Upload**. Tick "Automatically manage
   version and build number". Wait for the "processing complete" email (10–30 min).
4. **TestFlight**: add yourself and a few riders as internal or external testers. External
   testers need a short beta review (usually under 24 h), with "What to test" text.
5. Once the build is tested: version 1.0 → select the build → fill sections 2 to 8 → **Add
   for Review** → **Submit**. Choose "Manually release this version" to pick the launch day.
6. Review usually takes 24–48 h. Answer any message from App Review in Resolution Center.
