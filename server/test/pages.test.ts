import { describe, expect, it } from "vitest";
import { privacyPage, supportPage } from "../src/pages";

describe("pages", () => {
  it("privacy names the operator and contact, escaped", async () => {
    const res = privacyPage({ OPERATOR_NAME: "A <b>", CONTACT_EMAIL: "a@example.com" });
    expect(res.headers.get("Content-Type")).toContain("text/html");
    const html = await res.text();
    expect(html).toContain("A &lt;b&gt;");
    expect(html).not.toContain("a@example.com");   // not in clear in the source
    const decoded = html.replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)));
    expect(decoded).toContain('href="mailto:a@example.com"');
    expect(html).toContain("public");
  });
  it("falls back to GitHub issues without a contact", async () => {
    const html = await supportPage({}).text();
    expect(html).toContain("github.com/benjcvd/wheretokite/issues");
    expect(html).not.toContain("mailto:");
  });
});
