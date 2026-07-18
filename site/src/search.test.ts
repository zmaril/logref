import { expect, test } from "bun:test";
import { type LogSite, location, messageText, search } from "./search.ts";

const verifyCommon: LogSite = {
  api: "ereport",
  kind: "backend",
  level: "ERROR",
  message: { text: 'could not open parent table of index "%s"' },
  sqlstates: ["ERRCODE_UNDEFINED_TABLE"],
  path: "postgres/contrib/amcheck/verify_common.c",
  line: 127,
};

const verifyGin: LogSite = {
  api: "elog",
  kind: "backend",
  level: "DEBUG1",
  message: { text: "page blk: %u, type leaf" },
  path: "postgres/contrib/amcheck/verify_gin.c",
  line: 191,
};

const index: LogSite[] = [verifyCommon, verifyGin];

test("search matches message text case-insensitively", () => {
  const hits = search(index, "PARENT TABLE");
  expect(hits).toHaveLength(1);
  expect(hits[0]?.sqlstates).toEqual(["ERRCODE_UNDEFINED_TABLE"]);
});

test("empty query matches nothing", () => {
  expect(search(index, "   ")).toHaveLength(0);
});

test("location is path:line", () => {
  expect(location(verifyCommon)).toBe(
    "postgres/contrib/amcheck/verify_common.c:127",
  );
});

test("messageText falls back to expr", () => {
  const site: LogSite = {
    api: "elog",
    kind: "backend",
    message: { expr: "somevar" },
    path: "x.c",
    line: 1,
  };
  expect(messageText(site)).toBe("somevar");
});
