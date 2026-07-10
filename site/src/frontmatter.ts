// Parse the YAML frontmatter of a reference message page. The pages use a
// fixed, narrow schema (see reference/README.md), so rather than pull in a
// general YAML dependency we read exactly the shapes those pages use: JSON
// double-quoted scalars, inline flow arrays (`[a, b]`), block string lists, and
// the `sqlstate` block list of `{symbol, code}` mappings.

export interface SqlState {
  symbol: string;
  code: string;
}

export interface MessageDoc {
  message: string;
  slug: string;
  passthrough: boolean;
  api: string[];
  level: string[];
  levelRuntimeChosen: boolean;
  sqlstate: SqlState[];
  callSites: string[];
  reproduced: boolean;
  /** The markdown body after the closing `---`. */
  body: string;
}

/** Split a page into its raw frontmatter block and markdown body. */
function splitFrontmatter(raw: string): { yaml: string; body: string } {
  const match = raw.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
  if (!match) throw new Error("missing frontmatter");
  return { yaml: match[1]!, body: match[2]! };
}

/** A JSON double-quoted scalar (`"…"` with `\"` escapes) parses as JSON. */
function scalar(value: string): string {
  const trimmed = value.trim();
  if (trimmed.startsWith('"')) return JSON.parse(trimmed) as string;
  return trimmed;
}

/** An inline flow array, `[a, b, c]`, of bare or quoted items. */
function flowArray(value: string): string[] {
  const inner = value.trim().replace(/^\[/, "").replace(/\]$/, "").trim();
  if (inner === "") return [];
  return inner.split(",").map((item) => scalar(item));
}

export function parseFrontmatter(raw: string): MessageDoc {
  const { yaml, body } = splitFrontmatter(raw);
  const lines = yaml.split("\n");

  const doc: MessageDoc = {
    message: "",
    slug: "",
    passthrough: false,
    api: [],
    level: [],
    levelRuntimeChosen: false,
    sqlstate: [],
    callSites: [],
    reproduced: false,
    body,
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!;
    if (line.trim() === "" || /^\s/.test(line)) continue; // handled by blocks
    const kv = line.match(/^([a-z_]+):\s*(.*)$/);
    if (!kv) continue;
    const key = kv[1]!;
    const value = kv[2]!;

    switch (key) {
      case "message":
        doc.message = scalar(value);
        break;
      case "slug":
        doc.slug = scalar(value);
        break;
      case "passthrough":
        doc.passthrough = value.trim() === "true";
        break;
      case "reproduced":
        doc.reproduced = value.trim() === "true";
        break;
      case "level_runtime_chosen":
        doc.levelRuntimeChosen = value.trim() === "true";
        break;
      case "api":
        doc.api = flowArray(value);
        break;
      case "level":
        doc.level = flowArray(value);
        break;
      case "call_sites":
        doc.callSites = blockStrings(lines, i + 1);
        break;
      case "sqlstate":
        doc.sqlstate = blockSqlStates(lines, i + 1);
        break;
    }
  }

  return doc;
}

/** Read an indented block list of quoted strings starting at `from`. */
function blockStrings(lines: string[], from: number): string[] {
  const out: string[] = [];
  for (let i = from; i < lines.length; i++) {
    const item = lines[i]!.match(/^\s+-\s+(.*)$/);
    if (!item) {
      if (/^\S/.test(lines[i]!)) break; // next top-level key
      continue;
    }
    out.push(scalar(item[1]!));
  }
  return out;
}

/** Read the `sqlstate:` block list of `{symbol, code}` mappings. */
function blockSqlStates(lines: string[], from: number): SqlState[] {
  const out: SqlState[] = [];
  for (let i = from; i < lines.length; i++) {
    const line = lines[i]!;
    if (/^\S/.test(line)) break; // next top-level key
    const symbol = line.match(/^\s+-\s+symbol:\s*(.*)$/);
    if (symbol) {
      out.push({ symbol: scalar(symbol[1]!), code: "" });
      continue;
    }
    const code = line.match(/^\s+code:\s*(.*)$/);
    if (code && out.length > 0) out[out.length - 1]!.code = scalar(code[1]!);
  }
  return out;
}
