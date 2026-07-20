// Bundle entry: re-export the production TS scanner surface for the browser
// benchmark page. Bundled to ESM via `bun build` (see build.sh).
export { ScanIndex } from "../../../site/src/scanner.ts";
export { lowerFormat, renderSample } from "../../../site/src/lower.ts";
