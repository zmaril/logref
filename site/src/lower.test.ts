// Unit tests for the format-string → regex lowering, mirroring the Rust
// scanner's tests (crates/logref-core/src/scan.rs `mod tests`). Each case
// asserts both the exact lowered regex source and that a compiled RegExp
// captures the right groups from a rendered example — so any drift from the
// Rust lowering fails here.

import { expect, test } from "bun:test";
import { type Lowered, lowerFormat, renderSample } from "./lower.ts";

function lower(fmt: string): Lowered {
  return lowerFormat(fmt);
}

test("escapes literals and lowers string spec", () => {
  const l = lower('database "%s" does not exist');
  expect(l.regex).toBe('^database "(.*?)" does not exist$');
  expect(l.specCount).toBe(1);
  expect(l.groups).toEqual(["s"]);
  const caps = new RegExp(l.regex).exec('database "orders" does not exist');
  expect(caps?.[1]).toBe("orders");
});

test("bare string spec matches anything", () => {
  const l = lower("%s");
  expect(l.regex).toBe("^(.*?)$");
  expect(l.literalLen).toBe(0);
  expect(new RegExp(l.regex).test("literally anything")).toBe(true);
});

test("lowers integers and repeated specs", () => {
  const l = lower("%d of %d tuples");
  expect(l.regex).toBe("^(-?\\d+) of (-?\\d+) tuples$");
  expect(l.groups).toEqual(["d", "d"]);
  const caps = new RegExp(l.regex).exec("7 of 512 tuples");
  expect(caps?.[1]).toBe("7");
  expect(caps?.[2]).toBe("512");
  expect(new RegExp(l.regex).test("-3 of 4 tuples")).toBe(true);
});

test("lowers percent-m and quoted string", () => {
  const l = lower('could not open file "%s": %m');
  expect(l.regex).toBe('^could not open file "(.*?)": (.+?)$');
  expect(l.groups).toEqual(["s", "m"]);
  const caps = new RegExp(l.regex).exec(
    'could not open file "pg_wal/000001": No such file or directory',
  );
  expect(caps?.[1]).toBe("pg_wal/000001");
  expect(caps?.[2]).toBe("No such file or directory");
});

test("double percent is a literal percent", () => {
  const l = lower("disk is %d%% full");
  expect(l.regex).toBe("^disk is (-?\\d+)% full$");
  expect(l.specCount).toBe(1);
  const caps = new RegExp(l.regex).exec("disk is 90% full");
  expect(caps?.[1]).toBe("90");
});

test("parses width, precision, flags and length", () => {
  for (const fmt of [
    "%-5s",
    "%.2f",
    "%03d",
    "%*d",
    "%.*s",
    "%02X",
    "%ld",
    "%lld",
    "%zu",
  ]) {
    expect(() => lowerFormat(fmt)).not.toThrow();
  }
  // A width/precision spec matches its bare form's shape.
  expect(lower("%03d").regex).toBe("^(-?\\d+)$");
  expect(lower("%.2f").regex).toBe("^([-+0-9.eEpPxXaAfFnN]+)$");
});

test("parses positional specs", () => {
  const l = lower("%1$s contains %2$d rows");
  expect(l.regex).toBe("^(.*?) contains (-?\\d+) rows$");
  expect(new RegExp(l.regex).test("t contains 5 rows")).toBe(true);
});

test("rejects dangling percent and unknown conversion", () => {
  expect(() => lowerFormat("oops %")).toThrow("dangling");
  try {
    lowerFormat("%y is not real");
    throw new Error("should have thrown");
  } catch (e) {
    expect((e as { kind?: string }).kind).toBe("unknown-conversion");
    expect((e as { conversion?: string }).conversion).toBe("y");
  }
});

test("round-trips render through lowering", () => {
  for (const fmt of [
    'database "%s" does not exist',
    "%d of %d tuples",
    'could not open file "%s": %m',
    "value 0x%X out of range",
    "disk is %d%% full",
  ]) {
    const rendered = renderSample(fmt);
    expect(rendered).not.toBeNull();
    const re = new RegExp(lower(fmt).regex);
    expect(re.test(rendered as string)).toBe(true);
  }
});

test("hex, octal, pointer and char specs lower like Rust", () => {
  expect(lower("value 0x%X out of range").regex).toBe(
    "^value 0x([0-9a-fA-F]+) out of range$",
  );
  expect(lower("mode %o").regex).toBe("^mode ([0-7]+)$");
  expect(lower("at %p").regex).toBe("^at (0x[0-9a-fA-F]+|\\(nil\\))$");
  expect(lower("char %c").regex).toBe("^char (.)$");
  // %n writes nothing: no group, no literal.
  const n = lower("count%n done");
  expect(n.regex).toBe("^count done$");
  expect(n.specCount).toBe(0);
});
