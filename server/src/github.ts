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
      headers: {
        Authorization: `Bearer ${env.GITHUB_TOKEN}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "wheretokite-api",
        "Content-Type": "application/json",
      },
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
