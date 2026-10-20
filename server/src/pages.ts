// Public pages the App Store needs: privacy policy and support. Plain HTML, no cookies, no
// scripts. The operator's name and contact come from vars (wrangler.toml).

export interface PageEnv {
  /** Who runs the app (GDPR controller), e.g. "Jane Doe". */
  OPERATOR_NAME?: string;
  /** Contact address for privacy and support requests. */
  CONTACT_EMAIL?: string;
  GITHUB_REPO?: string;
}

const UPDATED = "20 October 2026";

const esc = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

function page(title: string, body: string): Response {
  const html = `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)} · WhereToKite</title>
<style>
:root { --bg: #fff; --fg: #1c1c1e; --muted: #6e6e73; --accent: #0a84ff; }
@media (prefers-color-scheme: dark) { :root { --bg: #000; --fg: #f2f2f7; --muted: #a1a1a6; --accent: #409cff; } }
body { background: var(--bg); color: var(--fg); font: 17px/1.55 -apple-system, system-ui, sans-serif;
       max-width: 42rem; margin: 0 auto; padding: 2rem 1rem 4rem; }
h1 { font-size: 1.8rem; margin-bottom: .2rem; } h2 { font-size: 1.15rem; margin-top: 2rem; }
.muted { color: var(--muted); font-size: .9rem; } a { color: var(--accent); }
table { border-collapse: collapse; width: 100%; font-size: .95rem; }
td, th { text-align: left; vertical-align: top; padding: .45rem .5rem .45rem 0; border-bottom: 1px solid #8884; }
</style></head><body>
${body}
<p class="muted" style="margin-top:3rem"><a href="/privacy">Privacy</a> · <a href="/support">Support</a></p>
</body></html>`;
  return new Response(html, {
    headers: { "Content-Type": "text/html; charset=utf-8", "Cache-Control": "public, max-age=3600" },
  });
}

function contact(env: PageEnv): string {
  const repo = env.GITHUB_REPO || "benjcvd/wheretokite";
  const mail = env.CONTACT_EMAIL ? `<a href="mailto:${esc(env.CONTACT_EMAIL)}">${esc(env.CONTACT_EMAIL)}</a>` : "";
  const issues = `<a href="https://github.com/${esc(repo)}/issues">GitHub issues</a>`;
  return mail ? `${mail} (or ${issues})` : issues;
}

export function privacyPage(env: PageEnv): Response {
  const who = env.OPERATOR_NAME ? esc(env.OPERATOR_NAME) : "the WhereToKite developer";
  return page("Privacy policy", `
<h1>Privacy policy</h1>
<p class="muted">Last updated ${UPDATED}</p>

<p>WhereToKite is run by ${who}, who is responsible for the data described here (the
“controller” under the GDPR). Contact: ${contact(env)}.</p>

<p><strong>In short:</strong> no account, no ads, no tracking, no selling of data. Your profile,
your own spots and your location stay on your phone.</p>

<h2>What stays on your phone</h2>
<p>Your rider profile (weight, level, kites), your own spots, your settings and the history of
“How was it?” answers. If you delete the app, they are deleted.</p>

<h2>What leaves your phone, and why</h2>
<table>
<tr><th>Data</th><th>Sent to</th><th>Why</th></tr>
<tr><td>Positions of kite spots, and the rough area of your start point (about 10 km)</td>
<td>The WhereToKite server, which asks Open-Meteo</td><td>Wind and tide forecasts</td></tr>
<tr><td>Your start point</td><td>Apple Maps, directly from your phone</td><td>Drive times</td></tr>
<tr><td>“How was it?” answers (spot, day, score, rating)</td><td>The WhereToKite server</td><td>Checking and improving the scores</td></tr>
<tr><td>Crash and performance reports from iOS (MetricKit)</td><td>The WhereToKite server</td><td>Fixing bugs</td></tr>
<tr><td>Reports you send (“Report an issue”): the category, your text, the spot, the app version and your country</td>
<td>The WhereToKite server, then a <strong>public</strong> issue on GitHub</td><td>Fixing the spot catalogue or the app in the open</td></tr>
</table>
<p>None of this includes your name, email, precise location or any identifier of you or your
device. Please don't write personal details in reports: they are public.</p>

<h2>Your IP address</h2>
<p>Like any internet service, the server sees the IP address of each request. It is used only
in memory to limit abuse (a maximum number of requests per minute) and is not stored by
WhereToKite. The hosting provider, Cloudflare, keeps technical request logs (which can include
the country and network) for a few days for operation and security.</p>

<h2>Legal basis</h2>
<p>Providing the forecasts you ask for (performance of the service) and legitimate interest
(keeping the service secure, fixing bugs and improving the spot catalogue). Nothing is used for
advertising or profiling.</p>

<h2>Service providers</h2>
<ul>
<li><strong>Cloudflare</strong> (hosting of the server; EU and US, under Cloudflare's data
processing terms and the EU–US Data Privacy Framework).</li>
<li><strong>Open-Meteo</strong> (weather forecasts, Switzerland). It receives spot positions
from the server, never anything about you.</li>
<li><strong>Apple</strong> (Maps, crash reports, and App Store purchases, under Apple's privacy policy).</li>
<li><strong>GitHub</strong> (public reports; US, Data Privacy Framework).</li>
</ul>

<h2>How long</h2>
<p>Forecast caches: hours. Server logs: a few days. Reports: until they are resolved, then
kept as public history unless you ask for removal.</p>

<h2>Your rights</h2>
<p>You can ask for access to, correction or deletion of data about you, for example a report
you sent, at ${contact(env)}. Since nothing identifies you, tell us which report it is. You
can also complain to your data protection authority (in France, the CNIL).</p>

<h2>Children</h2>
<p>WhereToKite is not directed at children under 13 and collects nothing that identifies anyone.</p>

<h2>Changes</h2>
<p>Changes to this policy are published on this page with a new date.</p>
`);
}

export function supportPage(env: PageEnv): Response {
  const repo = env.GITHUB_REPO || "benjcvd/wheretokite";
  return page("Support", `
<h1>WhereToKite support</h1>
<p>WhereToKite ranks kite spots within driving distance for the day and session you choose,
from wind forecasts, each beach's direction, tides and your kites.</p>

<h2>A spot is wrong or missing</h2>
<p>Use <strong>Report an issue</strong> on the spot's screen, or in <strong>Me → Report an issue</strong>
for a missing spot. Every report is checked against independent sources, and fixes reach the
app without an update.</p>

<h2>Something doesn't work</h2>
<p>Report it from the app (category “App problem”), open a
<a href="https://github.com/${esc(repo)}/issues/new">GitHub issue</a>${env.CONTACT_EMAIL ? `, or email <a href="mailto:${esc(env.CONTACT_EMAIL)}">${esc(env.CONTACT_EMAIL)}</a>` : ""}.</p>

<h2>Safety</h2>
<p>Scores are estimates from weather forecasts, not safety advice. Check the conditions and the
local rules on site, and ride at your own risk.</p>
`);
}
