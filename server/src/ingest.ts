// Anonymous app payloads (diagnostics, feedback, reports): validated, logged to Workers Logs.

import { ApiError, readLimited } from "./util";

export const MAX_INGEST_BYTES = 64 * 1024;
export type IngestKind = "diagnostics" | "feedback" | "report";

export async function handleIngest(
  request: Request,
  kind: IngestKind,
  log: (line: string) => void = console.log,
  /** Called with the validated payload after logging (reports -> GitHub issue). */
  after?: (payload: Record<string, unknown>, country?: string) => Promise<void>,
): Promise<Response> {
  const bytes = await readLimited(request, MAX_INGEST_BYTES);
  let payload: unknown;
  try {
    payload = JSON.parse(new TextDecoder().decode(bytes));
  } catch {
    throw new ApiError(400, "Body must be JSON");
  }
  if (payload === null || typeof payload !== "object") {
    throw new ApiError(400, "Body must be a JSON object or array");
  }
  // No IP or other identifier is logged; country is coarse and useful for spot coverage.
  const cf = (request as Request & { cf?: { country?: string } }).cf;
  log(JSON.stringify({ kind, bytes: bytes.byteLength, country: cf?.country, payload }));
  if (after && !Array.isArray(payload)) await after(payload as Record<string, unknown>, cf?.country);
  return new Response(null, { status: 204 });
}
