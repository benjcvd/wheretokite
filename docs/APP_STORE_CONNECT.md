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

- Non-trader now: Business → Agreements → Compliance → Digital Services Act → Complete
  Compliance Requirements → "This is not a trader account" → Done. No contact details asked.
- Trader later (before v2 with Pro is submitted): the app → App Information → App Store
  Regulations and Permits → Digital Services Act → Edit. The first time, you enter and verify
  the contact details shown on the store page.
- Apple's own page: [Manage EU DSA trader requirements](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements/).
  Apple says it can't decide for you and that it isn't legal advice.

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
| Privacy policy URL | `https://wheretokite-api.wheretokite-api.workers.dev/privacy`: entered on the **App Privacy** page (Edit next to Privacy Policy), once per language |
| Support URL | `https://wheretokite-api.wheretokite-api.workers.dev/support`: entered on the **version 1.0** page, once per language (English, Spanish, French) |
| Marketing URL | leave empty |
| Copyright | `2026 Benjamin Chevignard` (or your company name): on the **version 1.0** page, General App Information block, below the build |
| Content rights | "Yes, it contains third-party content, and I have the rights": weather from Open-Meteo (CC BY 4.0) and spots from OpenStreetMap (ODbL), both credited in the app |

## 3. Store listing (version 1.0)

**Promotional text** (170 max, can be changed anytime without review):

```
Tell it where you start, how far you'll drive and when you ride. WhereToKite checks the wind at every famous kite spot in reach and tells you where to go.
```

**Description** (4,000 max):

```
Where should you kite today? WhereToKite answers in one search.

Set your start point, how long you're willing to drive, the day and your session (morning, afternoon, evening or your own hours). WhereToKite checks the forecast at every well-known kite spot in reach and gives you a ranked list, with the best two-hour window at each spot. Up to three hours' drive and four days ahead.

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

The URLs are **not** shared: in each language, enter the same Support URL on the version page and
the same Privacy Policy URL on App Privacy, or Add for Review fails with "This field is required".

| Field | Value |
|---|---|
| Subtitle (30 max) | `Spots de kite según el viento` |

**Promotional text**:

```
Clasificación de los spots de kitesurf a tu alcance según la previsión de viento, para el día y la franja horaria que elijas. Europa y Marruecos.
```

**Description**:

```
WhereToKite indica en qué spots de kitesurf habrá mejores condiciones para un día y una franja horaria concretos.

Indicas tu punto de salida, el tiempo máximo de trayecto, el día y la franja (temprano, tarde, atardecer u horario personalizado). La app consulta la previsión de cada spot al que puedes llegar en ese tiempo y los ordena, con la mejor ventana de dos horas de cada uno. Trayectos de hasta tres horas y previsión de hasta cuatro días.

CÓMO SE PUNTÚA
Indicas una vez tu peso, tu nivel y tus cometas. Cada hora se puntúa según:
• la fuerza del viento, comparada con el rango de uso de tus cometas;
• la regularidad del viento (rachas frente al viento medio);
• la dirección del viento respecto a la orientación de la playa. El viento offshore puntúa cero.

SPOTS
Más de 600 spots de kitesurf conocidos en Europa y Marruecos. La orientación de cada playa se calcula a partir de los datos cartográficos de OpenStreetMap y se comprueba. En los spots que dependen de la marea se tiene en cuenta la previsión de mareas, así como las prohibiciones de temporada y las zonas de baño de verano.

SEGURIDAD
Las horas con riesgo de tormenta, las horas nocturnas y los periodos de prohibición puntúan cero. Un índice de fiabilidad indica en qué medida coinciden los modelos meteorológicos para el día elegido.

OTRAS FUNCIONES
• Tiempos de trayecto calculados con Mapas de Apple.
• Gráfico horario de viento y rachas para cada spot, e indicaciones para llegar.
• Añadir tus propios spots, que se ordenan igual que los demás.
• Avisar de un error en un spot desde la app; las correcciones se aplican sin actualizar la app.

DATOS PERSONALES
No hace falta cuenta. Tu perfil y tus spots se quedan en tu teléfono. Sin publicidad ni rastreo.

Las puntuaciones son estimaciones basadas en previsiones meteorológicas y no son un consejo de seguridad. Comprueba siempre las condiciones y la normativa local en el spot.

Datos meteorológicos: Open-Meteo.com. Spots: © colaboradores de OpenStreetMap.
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
| Subtitle (30 max) | `Spots de kite selon le vent` |

**Promotional text**:

```
Classement des spots de kitesurf à portée de route selon la prévision de vent, pour le jour et le créneau de votre choix. Europe et Maroc.
```

**Description**:

```
WhereToKite indique les spots de kitesurf où les conditions seront les meilleures pour un jour et un créneau donnés.

Vous indiquez votre point de départ, le temps de route maximum, le jour et le créneau (matin, après-midi, soir ou horaires personnalisés). L'application récupère la prévision de chaque spot accessible dans ce temps de route et les classe, avec pour chacun le meilleur créneau de deux heures. Temps de route jusqu'à trois heures, prévisions jusqu'à quatre jours.

CALCUL DE LA NOTE
Vous renseignez une fois votre poids, votre niveau et vos ailes. Chaque heure est notée selon :
• la force du vent, comparée à la plage d'utilisation de vos ailes ;
• la régularité du vent (rafales par rapport au vent moyen) ;
• la direction du vent par rapport à l'orientation de la plage. Un vent offshore donne une note nulle.

SPOTS
Plus de 600 spots de kitesurf connus en Europe et au Maroc. L'orientation de chaque plage est calculée à partir des données cartographiques d'OpenStreetMap, puis vérifiée. Pour les spots qui dépendent de la marée, la prévision de marée est prise en compte, ainsi que les interdictions saisonnières et les zones de baignade estivales.

SÉCURITÉ
Les heures avec risque d'orage, les heures de nuit et les périodes d'interdiction reçoivent une note nulle. Un indice de confiance indique dans quelle mesure les modèles météo concordent pour le jour choisi.

AUTRES FONCTIONS
• Temps de trajet calculés avec Apple Plans.
• Graphique horaire du vent et des rafales pour chaque spot, et itinéraire.
• Ajout de vos propres spots, classés comme les autres.
• Signalement d'une erreur sur un spot depuis l'application ; les corrections sont appliquées sans mise à jour.

DONNÉES PERSONNELLES
Aucun compte n'est nécessaire. Votre profil et vos spots restent sur votre téléphone. Pas de publicité, pas de pistage.

Les notes sont des estimations calculées à partir de prévisions météo et ne constituent pas un avis de sécurité. Vérifiez toujours les conditions et la réglementation locale sur place.

Données météo : Open-Meteo.com. Spots : © contributeurs OpenStreetMap.
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

Directions: the phone hands the spot to Apple Maps or Google Maps (the rider's pick). That is the
rider opening another app, not collection by WhereToKite: nothing to declare, no SDK involved.

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
