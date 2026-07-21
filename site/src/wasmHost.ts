// Load the wasm scanner module under Bun (build time + tests). The
// wasm-bindgen `--target web` glue expects to fetch its .wasm over HTTP; here
// we hand it the module bytes from disk instead, once, and share the
// initialized namespace. The browser page (scan.ts) initializes the same glue
// itself with the fetchable dist/ URL.
//
// The glue + module live in src/wasm/ and are BUILT, not committed — run
// `bun run build:wasm` (scripts/build-wasm-web.sh; needs cargo + the
// wasm32-unknown-unknown target + wasm-bindgen) before building or testing.

import { join } from "node:path";
import type * as wasm from "./wasm/logref_wasm.js";

export const WASM_FILE = join(import.meta.dir, "wasm", "logref_wasm_bg.wasm");

let ready: Promise<typeof wasm> | undefined;

/** Initialize the wasm module from disk (idempotent) and return its exports. */
export function loadWasm(): Promise<typeof wasm> {
  ready ??= (async () => {
    let glue: typeof wasm;
    try {
      glue = await import("./wasm/logref_wasm.js");
    } catch (e) {
      throw new Error(
        "wasm scanner artifacts missing from site/src/wasm/ — run `bun run build:wasm` first",
        { cause: e },
      );
    }
    await glue.default({ module_or_path: Bun.file(WASM_FILE).arrayBuffer() });
    return glue;
  })();
  return ready;
}
