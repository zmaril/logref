// Format-string → regex lowering — a faithful TypeScript port of the Rust
// scanner's lowering (crates/logref-core/src/scan.rs). The `Scan` surface
// resolves a *rendered* log line — the concrete text a user actually saw — back
// to the `%s`-parameterized format string in the index, and thus to its source
// call site.
//
// Lowering turns a Postgres/C `printf`/`errmsg` format string into an anchored
// regex: literal runs are escaped verbatim, each conversion spec (`%s`, `%d`,
// `%m`, width/precision/positional forms) becomes a capture group sized to what
// it can render. The regex source produced here is byte-for-byte identical to
// the Rust `lower_format` output, so the two scanners resolve lines the same way.

/** Why a format string could not be lowered to a regex. */
export type LowerErrorKind = "dangling-percent" | "unknown-conversion";

/** Thrown by {@link lowerFormat} when a format string cannot be lowered. */
export class LowerError extends Error {
  readonly kind: LowerErrorKind;
  /** The offending conversion character for `unknown-conversion`. */
  readonly conversion?: string;
  constructor(kind: LowerErrorKind, conversion?: string) {
    super(
      kind === "dangling-percent"
        ? "format string ends with a dangling '%'"
        : `unknown conversion specifier '%${conversion}'`,
    );
    this.name = "LowerError";
    this.kind = kind;
    this.conversion = conversion;
  }
}

/** A format string lowered to a regex, plus specificity signals + group provenance. */
export interface Lowered {
  /** The anchored regex source (`^…$`). */
  regex: string;
  /**
   * Count of *literal* characters (everything that is not a conversion spec's
   * capture group). The specificity signal used to rank competing matches — a
   * bare `"%s"` has `literalLen === 0` and matches everything, whereas
   * `database "%s" does not exist` has 25.
   */
  literalLen: number;
  /** Number of conversion specs (capture groups) in the pattern. */
  specCount: number;
  /**
   * The conversion character for each capture group, in order. `database "%s"
   * does not exist` yields `["s"]`; `%d of %d tuples` yields `["d", "d"]`. Lets
   * the UI label each extracted value with the `%`-spec it came from. `%n` and
   * `%%` contribute no group and no entry.
   */
  groups: string[];
  /**
   * The maximal literal runs between conversion specs (each unescaped, `%%`
   * folded to `%`). Every one of these must appear verbatim in any line the
   * pattern matches, so the scanner uses them to build a sound trigram prefilter.
   * `database "%s" does not exist` yields `['database "', '" does not exist']`.
   */
  literals: string[];
}

/**
 * The set of characters `regex::escape` (regex-syntax's `is_meta_character`)
 * escapes. Kept identical to Rust so literal runs lower byte-for-byte the same.
 * `-` is placed last in the class so it is a literal, `]` is escaped.
 */
const META = /[\\.+*?()|[\]{}^$#&~-]/g;

/** Escape regex metacharacters exactly as Rust's `regex::escape` does. */
export function escapeRegex(literal: string): string {
  return literal.replace(META, (c) => `\\${c}`);
}

/**
 * Consume a field-width-style token starting at `chars[i]`: a single `*`
 * (argument-supplied width) or a run of decimal digits. Returns the index just
 * past it, or `i` unchanged when neither is present. Shared by the field width
 * and precision parsers, which accept the same token.
 */
function consumeWidth(chars: string[], i: number): number {
  if (i < chars.length && chars[i] === "*") return i + 1;
  while (i < chars.length && isAsciiDigit(chars[i]!)) i++;
  return i;
}

function isAsciiDigit(c: string): boolean {
  return c >= "0" && c <= "9";
}

/**
 * Consume a `printf`-style conversion spec that begins at `chars[start]` (which
 * must be `%`, and not the start of `%%`). Returns the conversion character and
 * the index just past the whole spec.
 */
function parseSpec(chars: string[], start: number): [string, number] {
  let i = start + 1; // skip '%'

  // Positional argument: digits followed by '$'.
  let j = i;
  while (j < chars.length && isAsciiDigit(chars[j]!)) j++;
  if (j > i && j < chars.length && chars[j] === "$") i = j + 1;

  // Flags.
  while (
    i < chars.length &&
    (chars[i] === "-" ||
      chars[i] === "+" ||
      chars[i] === " " ||
      chars[i] === "0" ||
      chars[i] === "#" ||
      chars[i] === "'")
  ) {
    i++;
  }
  // Field width: a run of digits or a single '*' (argument-supplied width).
  i = consumeWidth(chars, i);
  // Precision: '.' then digits or '*'.
  if (i < chars.length && chars[i] === ".") {
    i++;
    i = consumeWidth(chars, i);
  }
  // Length modifier: hh, ll (two-char) then h, l, L, q, j, z, t (one-char).
  if (
    i + 1 < chars.length &&
    (chars[i] === "h" || chars[i] === "l") &&
    chars[i + 1] === chars[i]
  ) {
    i += 2;
  } else if (
    i < chars.length &&
    (chars[i] === "h" ||
      chars[i] === "l" ||
      chars[i] === "L" ||
      chars[i] === "q" ||
      chars[i] === "j" ||
      chars[i] === "z" ||
      chars[i] === "t")
  ) {
    i++;
  }
  // Conversion.
  if (i >= chars.length) throw new LowerError("dangling-percent");
  return [chars[i]!, i + 1];
}

/**
 * The regex fragment a conversion character lowers to, or `null` for `%n`
 * (which writes nothing to the output). Throws for anything unrecognized.
 */
function conversionGroup(conv: string): string | null {
  switch (conv) {
    case "s":
      return "(.*?)";
    case "d":
    case "i":
      return "(-?\\d+)";
    case "u":
      return "(\\d+)";
    case "o":
      return "([0-7]+)";
    case "x":
    case "X":
      return "([0-9a-fA-F]+)";
    case "e":
    case "E":
    case "f":
    case "F":
    case "g":
    case "G":
    case "a":
    case "A":
      return "([-+0-9.eEpPxXaAfFnN]+)";
    case "c":
      return "(.)";
    case "p":
      return "(0x[0-9a-fA-F]+|\\(nil\\))";
    // Postgres %m expands to strerror(errno) — arbitrary prose.
    case "m":
      return "(.+?)";
    case "n":
      return null;
    default:
      throw new LowerError("unknown-conversion", conv);
  }
}

/**
 * Lower a Postgres/C `printf`-style format string into an anchored regex.
 *
 * Literal runs are regex-escaped; each conversion spec becomes a capture group.
 * Width, precision, flags, length modifiers and positional (`%1$s`) forms are
 * parsed and discarded — they affect rendering, not what characters can appear —
 * so `%-5s`, `%.2f`, `%03d`, `%*d`, `%1$s` all lower like their bare form. `%%`
 * becomes a literal `%`. Throws {@link LowerError} on a dangling `%` or an
 * unknown conversion.
 */
export function lowerFormat(fmt: string): Lowered {
  const chars = Array.from(fmt);
  let out = "^";
  let literal = "";
  let literalLen = 0;
  let specCount = 0;
  const groups: string[] = [];
  const literals: string[] = [];
  let i = 0;

  const flush = () => {
    if (literal !== "") {
      out += escapeRegex(literal);
      literals.push(literal);
      literal = "";
    }
  };

  while (i < chars.length) {
    const c = chars[i]!;
    if (c !== "%") {
      literal += c;
      literalLen++;
      i++;
      continue;
    }
    // A '%'. Handle the '%%' literal-percent case first.
    if (i + 1 < chars.length && chars[i + 1] === "%") {
      literal += "%";
      literalLen++;
      i += 2;
      continue;
    }
    const [conv, next] = parseSpec(chars, i);
    const group = conversionGroup(conv);
    if (group !== null) {
      flush();
      out += group;
      specCount++;
      groups.push(conv);
    }
    i = next;
  }
  flush();
  out += "$";
  return { regex: out, literalLen, specCount, groups, literals };
}

/** Lower without throwing: returns the {@link Lowered} or `null` on any error. */
export function tryLowerFormat(fmt: string): Lowered | null {
  try {
    return lowerFormat(fmt);
  } catch {
    return null;
  }
}

/**
 * Render a format string with canned, plausible values — the inverse of
 * {@link lowerFormat}, used to synthesize sample log lines and to round-trip
 * test the lowering. Returns `null` if the format contains a spec that lowering
 * itself would reject.
 */
export function renderSample(fmt: string): string | null {
  const chars = Array.from(fmt);
  let out = "";
  let i = 0;
  while (i < chars.length) {
    const c = chars[i]!;
    if (c !== "%") {
      out += c;
      i++;
      continue;
    }
    if (i + 1 < chars.length && chars[i + 1] === "%") {
      out += "%";
      i += 2;
      continue;
    }
    let conv: string;
    let next: number;
    try {
      [conv, next] = parseSpec(chars, i);
    } catch {
      return null;
    }
    let value: string;
    switch (conv) {
      case "s":
        value = "widget";
        break;
      case "d":
      case "i":
        value = "42";
        break;
      case "u":
        value = "42";
        break;
      case "o":
        value = "52";
        break;
      case "x":
        value = "2a";
        break;
      case "X":
        value = "2A";
        break;
      case "e":
      case "E":
      case "f":
      case "F":
      case "g":
      case "G":
      case "a":
      case "A":
        value = "1.5";
        break;
      case "c":
        value = "Q";
        break;
      case "p":
        value = "0x55a0";
        break;
      case "m":
        value = "No such file or directory";
        break;
      case "n":
        value = "";
        break;
      default:
        return null;
    }
    out += value;
    i = next;
  }
  return out;
}
