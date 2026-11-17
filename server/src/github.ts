// App reports ("Report an issue") filed as GitHub issues on the repo, so the owner gets
// notified and each fix links to its report. Needs the GITHUB_TOKEN secret (a fine-grained
// token with Issues: read & write on the repo); without it, reports are only logged.

export interface IssueDraft {
  title: string;
  body: string;
  labels: string[];
}

const str = (v: unknown, max: number): string =>
  typeof v === "string" ? v.slice(0, max) : typeof v === "number" ? String(v) : "";

/** Neutralise @mentions and links so a report can't ping people or carry clickable spam. */
export function sanitize(text: string): string {
  return text
    .replace(/@/g, "@​")
    .replace(/https?:\/\//gi, (m) => m.replace("://", ":​//"))
    .replace(/\r/g, "");
}

/** "fr-wissant" -> "tools/spots/FR*.csv" (country prefix of the spot id). */
export function catalogFileHint(spotId: string): string | undefined {
  const m = /^([a-z]{2})-/.exec(spotId);
  return m ? `tools/spots/${m[1].toUpperCase()}*.csv` : undefined;
}

export function buildIssue(payload: Record<string, unknown>, country?: string): IssueDraft {
  const kind = sanitize(str(payload.kind, 80)) || "Report";
  const spotId = str(payload.spotId, 100).replace(/[^a-z0-9-]/gi, "");
  const spotName = sanitize(str(payload.spotName, 200));
  const missing = sanitize(str(payload.missingSpot, 200));
  const message = sanitize(str(payload.message, 2000));
  const subject = spotName || missing || "app";
  const lines = [
    `**${kind}**`,
    "",
    spotId ? `- Spot: ${spotName} (\`${spotId}\`)` : "",
    spotId && catalogFileHint(spotId) ? `- Catalogue file: \`${catalogFileHint(spotId)}\`` : "",
    missing ? `- Missing spot: ${missing}` : "",
    country ? `- Reported from: ${country}` : "",
    payload.appVersion ? `- App: ${sanitize(str(payload.appVersion, 40))}` : "",
    "",
    message ? message.split("\n").map((l) => `> ${l}`).join("\n") : "_No details._",
    "",
    "<sub>Sent anonymously from the app.</sub>",
  ].filter((l, i, a) => l !== "" || (i > 0 && a[i - 1] !== ""));
  return {
    title: `${kind}: ${subject}`.slice(0, 120),
    body: lines.join("\n"),
    labels: ["report", kind.toLowerCase().includes("missing") ? "missing spot" : spotId ? "spot" : "app"],
  };
}

/** Issues filed from the app per rolling 24 h, across all users (spam ceiling). */
export const DEFAULT_REPORT_ISSUES_PER_DAY = 15;

const ghHeaders = (token: string): Record<string, string> => ({
  Authorization: `Bearer ${token}`,
  Accept: "application/vnd.github+json",
  "X-GitHub-Api-Version": "2022-11-28",
  "User-Agent": "wheretokite-api",
});

/**
 * Number of `report` issues created in the last 24 h, or undefined if GitHub can't say.
 * Lists issues updated since then (a superset) and counts those created since then.
 */
export async function reportsFiledLastDay(
  env: { GITHUB_TOKEN?: string; GITHUB_REPO?: string },
  doFetch: typeof fetch,
  now: number,
): Promise<number | undefined> {
  if (!env.GITHUB_TOKEN) return undefined;
  const repo = env.GITHUB_REPO || "benjcvd/wheretokite";
  const since = new Date(now - 24 * 3600 * 1000).toISOString();
  try {
    const res = await doFetch(
      `https://api.github.com/repos/${repo}/issues?labels=report&state=all&since=${since}&per_page=100`,
      { headers: ghHeaders(env.GITHUB_TOKEN) },
    );
    if (!res.ok) return undefined;
    const items = (await res.json()) as { created_at?: string }[];
    return items.filter((i) => i.created_at && i.created_at >= since).length;
  } catch {
    return undefined;
  }
}

/**
 * Files a report issue unless today's ceiling is reached. Fails closed: if GitHub can't
 * tell how many were filed, nothing is filed (the report is still in Workers Logs).
 */
export async function fileReportIssue(
  draft: IssueDraft,
  env: { GITHUB_TOKEN?: string; GITHUB_REPO?: string; REPORT_ISSUES_PER_DAY?: string },
  doFetch: typeof fetch,
  now: number,
): Promise<string | undefined> {
  if (!env.GITHUB_TOKEN) return undefined;
  const cap = Number(env.REPORT_ISSUES_PER_DAY) || DEFAULT_REPORT_ISSUES_PER_DAY;
  const filed = await reportsFiledLastDay(env, doFetch, now);
  if (filed === undefined || filed >= cap) {
    console.log(JSON.stringify({ kind: "github_issue_skipped", reason: filed === undefined ? "count_failed" : "daily_cap", filed, cap }));
    return undefined;
  }
  return fileIssue(draft, env, doFetch);
}

/** Files the issue; returns its URL, or undefined when not configured / it failed (logged). */
export async function fileIssue(
  draft: IssueDraft,
  env: { GITHUB_TOKEN?: string; GITHUB_REPO?: string },
  doFetch: typeof fetch,
): Promise<string | undefined> {
  if (!env.GITHUB_TOKEN) return undefined;
  const repo = env.GITHUB_REPO || "benjcvd/wheretokite";
  try {
    const res = await doFetch(`https://api.github.com/repos/${repo}/issues`, {
      method: "POST",
      headers: { ...ghHeaders(env.GITHUB_TOKEN), "Content-Type": "application/json" },
      body: JSON.stringify(draft),
    });
    if (!res.ok) {
      console.error(JSON.stringify({ kind: "github_issue_failed", status: res.status, body: (await res.text()).slice(0, 300) }));
      return undefined;
    }
    const issue = (await res.json()) as { html_url?: string };
    return issue.html_url;
  } catch (e) {
    console.error(JSON.stringify({ kind: "github_issue_failed", error: String(e) }));
    return undefined;
  }
}

// ---- Forecast quota alert ----

export const QUOTA_TITLE = "Forecast quota hit";

/** Start of the UTC day containing `now`, as an ISO string. */
const dayStart = (now: number): string => new Date(Math.floor(now / 86_400_000) * 86_400_000).toISOString();

/**
 * Files one "Forecast quota hit" issue per UTC day when Open-Meteo answers 429, so the owner
 * hears about it (phones fall back to Open-Meteo directly, silently). Checks today's issues
 * by title first (the label may not exist on the repo); fails closed if GitHub can't say.
 * Returns the new issue's URL, or undefined (already filed today, not configured, or failed).
 */
export async function fileQuotaAlert(
  reason: string,
  env: { GITHUB_TOKEN?: string; GITHUB_REPO?: string },
  doFetch: typeof fetch,
  now: number,
): Promise<string | undefined> {
  if (!env.GITHUB_TOKEN) return undefined;
  const repo = env.GITHUB_REPO || "benjcvd/wheretokite";
  const since = dayStart(now);
  try {
    const res = await doFetch(`https://api.github.com/repos/${repo}/issues?state=all&since=${since}&per_page=100`, {
      headers: ghHeaders(env.GITHUB_TOKEN),
    });
    if (!res.ok) return undefined;
    const items = (await res.json()) as { title?: string; created_at?: string }[];
    if (items.some((i) => i.title?.startsWith(QUOTA_TITLE) && i.created_at && i.created_at >= since)) return undefined;
  } catch {
    return undefined;
  }
  const day = since.slice(0, 10);
  return fileIssue(
    {
      title: `${QUOTA_TITLE}: ${day}`,
      body: [
        `Open-Meteo refused a forecast request from the server on ${day} (UTC) with HTTP 429:`,
        "",
        `> ${sanitize(reason) || "_no reason given_"}`,
        "",
        "Phones keep working: after a server error they ask Open-Meteo directly for 10 minutes.",
        "If this repeats, the free tier (10,000 calls a day, non-commercial) is too small: see",
        "the Open-Meteo plan card on the board. Workers Logs show each hit as `upstream_quota`.",
        "",
        "<sub>Filed by the server, at most once a day.</sub>",
      ].join("\n"),
      labels: ["quota"],
    },
    env,
    doFetch,
  );
}
