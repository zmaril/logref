import { expect, test } from "bun:test";
import type { MessageDoc } from "./frontmatter.ts";
import { messagePage, sourceSection, sqlstateSection } from "./render.ts";

function doc(overrides: Partial<MessageDoc> = {}): MessageDoc {
  return {
    message: "smallint out of range",
    slug: "smallint-out-of-range",
    passthrough: false,
    api: ["ereport"],
    level: ["ERROR"],
    levelRuntimeChosen: false,
    sqlstate: [
      { symbol: "ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE", code: "22003" },
    ],
    callSites: [
      "postgres/contrib/btree_gist/btree_int2.c:106",
      "postgres/src/backend/utils/adt/int.c:920",
    ],
    reproduced: true,
    body: "# `smallint out of range`\n\n## What it means\n\nToo big.\n\n## Related\n\n- [x](./x.md)\n",
    ...overrides,
  };
}

test("Source section links each call site to GitHub (prefix dropped, #L anchor)", () => {
  const html = sourceSection(doc());
  expect(html).toContain("<h2>Source</h2>");
  expect(html).toContain("emitted from 2 call sites");
  expect(html).toContain(
    'href="https://github.com/postgres/postgres/blob/master/contrib/btree_gist/btree_int2.c#L106"',
  );
  expect(html).toContain(
    'href="https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L920"',
  );
  // The label keeps the full path:line.
  expect(html).toContain(
    "<code>postgres/src/backend/utils/adt/int.c:920</code>",
  );
});

test("Source section uses singular prose for a single call site", () => {
  const html = sourceSection(
    doc({ callSites: ["postgres/src/backend/commands/user.c:1758"] }),
  );
  expect(html).toContain("Emitted from");
  expect(html).not.toContain("call sites:");
});

test("SQLSTATE section renders code, symbol, and error class", () => {
  const html = sqlstateSection(doc());
  expect(html).toBe(
    "<h2>SQLSTATE</h2>\n<ul><li><code>22003</code> — <strong>ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE</strong>. Class 22 (Data Exception).</li></ul>",
  );
});

test("SQLSTATE section handles a symbol without a mapped code", () => {
  const html = sqlstateSection(
    doc({ sqlstate: [{ symbol: "ERRCODE_INVALID_GRANT_OPERATION", code: "" }] }),
  );
  expect(html).toContain("<strong>ERRCODE_INVALID_GRANT_OPERATION</strong>");
  expect(html).toContain("outside the pilot's code map");
  expect(html).not.toContain("Class ");
});

test("SQLSTATE section is empty when the message has no SQLSTATE", () => {
  expect(sqlstateSection(doc({ sqlstate: [] }))).toBe("");
});

test("each derived fact appears exactly once on the full page", () => {
  const html = messagePage(doc());
  const count = (needle: string) => html.split(needle).length - 1;
  // Severity is the facts-card badge only; the SQLSTATE code lives only in the
  // SQLSTATE section (not repeated in the facts card or a severity preamble).
  expect(count("<h2>Source</h2>")).toBe(1);
  expect(count("<h2>SQLSTATE</h2>")).toBe(1);
  expect(count("22003")).toBe(1);
  expect(count('fact-label">Severity')).toBe(1);
  expect(count('fact-label">SQLSTATE')).toBe(0);
  // The generated sections sit before Related, preserving template order.
  expect(html.indexOf("<h2>Source</h2>")).toBeLessThan(
    html.indexOf("<h2>SQLSTATE</h2>"),
  );
  expect(html.indexOf("<h2>SQLSTATE</h2>")).toBeLessThan(
    html.indexOf(">Related<"),
  );
});

test("passthrough page renders Source but omits SQLSTATE", () => {
  const html = messagePage(
    doc({
      passthrough: true,
      sqlstate: [],
      callSites: ["postgres/src/backend/tcop/postgres.c:5342"],
      body: "# `%s`\n\n## What it means\n\nVaries.\n\n## Related\n\n- [x](./x.md)\n",
    }),
  );
  expect(html).toContain("<h2>Source</h2>");
  expect(html).not.toContain("<h2>SQLSTATE</h2>");
  expect(html).toContain("varies by call site");
});
