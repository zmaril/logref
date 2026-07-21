// Decoder for the wasm `Scanner.scanBatchPacked` result: the whole batch's
// hits arrive as ONE flat Int32Array (a single bulk copy across the wasm
// boundary instead of ~75k serde-built JS objects), and this module
// reconstructs the per-line `{site, literalLen, captures[]}` hits by slicing
// each input line by the returned capture spans.
//
// Layout (see `ScannerImpl::scan_batch_packed_buf` in
// crates/logref-wasm/src/core_impl.rs), read sequentially — per line, in order:
//
//   [ numHits, (site, literalLen, numCaps, (capStart, capEnd)*)* ]
//
// An unmatched optional group is (-1, -1) and reconstructs to "".
//
// The spans are UTF-8 **byte** offsets into the line; JS strings index UTF-16
// code units. For ASCII lines (the overwhelming log common case) the two
// coincide and we slice directly; a line containing any non-ASCII char is
// instead encoded once to UTF-8 and its captures decoded from the byte buffer,
// so the reconstruction is exact for every input.

/** One decoded hit: the catalog site index, its specificity, and the captured
 * values pulled from the scanned line. Mirrors the wasm `MatchHit`. */
export interface PackedHit {
  site: number;
  literalLen: number;
  captures: string[];
}

const encoder = new TextEncoder();
const decoder = new TextDecoder();

/** True when every char of `s` is ASCII (byte offsets == UTF-16 offsets). */
function isAscii(s: string): boolean {
  // biome-ignore lint/suspicious/noControlCharactersInRegex: the ASCII range test is the point
  return !/[^\x00-\x7F]/.test(s);
}

/**
 * Decode one packed batch result back into per-line hits. `lines` must be the
 * exact array passed to `scanBatchPacked` — the capture spans index into it.
 */
export function decodePacked(
  arr: Int32Array,
  lines: readonly string[],
): PackedHit[][] {
  const out: PackedHit[][] = new Array(lines.length);
  let p = 0;
  for (let li = 0; li < lines.length; li++) {
    const numHits = arr[p++]!;
    const hits: PackedHit[] = new Array(numHits);
    const line = lines[li]!;
    // Byte-offset spans: slice the string directly when ASCII, else go through
    // the line's UTF-8 bytes so multi-byte chars can't skew the offsets.
    const ascii = isAscii(line);
    const bytes = ascii ? null : encoder.encode(line);
    for (let h = 0; h < numHits; h++) {
      const site = arr[p++]!;
      const literalLen = arr[p++]!;
      const numCaps = arr[p++]!;
      const captures: string[] = new Array(numCaps);
      for (let c = 0; c < numCaps; c++) {
        const s = arr[p++]!;
        const e = arr[p++]!;
        captures[c] =
          s < 0
            ? ""
            : bytes === null
              ? line.slice(s, e)
              : decoder.decode(bytes.subarray(s, e));
      }
      hits[h] = { site, literalLen, captures };
    }
    out[li] = hits;
  }
  return out;
}
