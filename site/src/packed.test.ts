// Unit tests for the packed-result decoder: the layout contract with
// `ScannerImpl::scan_batch_packed_buf` (crates/logref-wasm/src/core_impl.rs),
// exercised on hand-built buffers so the decode logic is pinned independently
// of the wasm module — plus the UTF-8 span handling for non-ASCII lines.

import { expect, test } from "bun:test";
import { decodePacked } from "./packed.ts";

test("decodes an empty batch", () => {
  expect(decodePacked(new Int32Array([]), [])).toEqual([]);
});

test("decodes a no-hit line and a multi-hit line", () => {
  const lines = ["nothing", "abc 42"];
  // line 0: 0 hits. line 1: two hits — site 7 (lit 4) capturing "42"
  // (bytes 4..6), and site 1 (lit 0) capturing the whole line (0..6).
  const arr = new Int32Array([
    0, //
    2,
    7,
    4,
    1,
    4,
    6,
    1,
    0,
    1,
    0,
    6,
  ]);
  expect(decodePacked(arr, lines)).toEqual([
    [],
    [
      { site: 7, literalLen: 4, captures: ["42"] },
      { site: 1, literalLen: 0, captures: ["abc 42"] },
    ],
  ]);
});

test("an unmatched optional group (-1,-1) reconstructs to the empty string", () => {
  const arr = new Int32Array([1, 3, 2, 2, -1, -1, 0, 1]);
  expect(decodePacked(arr, ["xy"])).toEqual([
    [{ site: 3, literalLen: 2, captures: ["", "x"] }],
  ]);
});

test("a zero-length span slices to the empty string (an empty %s capture)", () => {
  const arr = new Int32Array([1, 0, 5, 1, 2, 2]);
  expect(decodePacked(arr, ["abcd"])).toEqual([
    [{ site: 0, literalLen: 5, captures: [""] }],
  ]);
});

test("non-ASCII lines decode by UTF-8 byte offsets, not UTF-16 indices", () => {
  // 'héllo wörld': h=1 byte, é=2 bytes → 'wörld' starts at BYTE 7 (UTF-16
  // index 6). A byte span (7, 13) must yield "wörld" exactly.
  const line = "héllo wörld";
  const arr = new Int32Array([1, 4, 6, 1, 7, 13]);
  expect(decodePacked(arr, [line])).toEqual([
    [{ site: 4, literalLen: 6, captures: ["wörld"] }],
  ]);
});

test("multiple lines advance the read cursor correctly", () => {
  const lines = ["aa", "bb", "cc"];
  const arr = new Int32Array([
    1,
    0,
    1,
    1,
    0,
    2, //
    0, //
    1,
    2,
    3,
    0,
  ]);
  expect(decodePacked(arr, lines)).toEqual([
    [{ site: 0, literalLen: 1, captures: ["aa"] }],
    [],
    [{ site: 2, literalLen: 3, captures: [] }],
  ]);
});
