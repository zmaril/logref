// Tests for log-prefix stripping (ported unchanged from the retired
// scanner.test.ts — the behavior is a site-level choice that survived the
// swap to the wasm scanner).

import { expect, test } from "bun:test";
import { stripLogPrefix } from "./prefix.ts";

test("strips a full Postgres log prefix down to the bare message", () => {
  const { core, level } = stripLogPrefix(
    '2024-01-01 12:00:00.123 UTC [1234] user@db ERROR:  relation "orders" does not exist',
  );
  expect(core).toBe('relation "orders" does not exist');
  expect(level).toBe("ERROR");
});

test("strips a bare severity prefix", () => {
  const { core, level } = stripLogPrefix(
    "FATAL:  the database system is starting up",
  );
  expect(core).toBe("the database system is starting up");
  expect(level).toBe("FATAL");
});

test("keeps an unprefixed line intact (no level detected)", () => {
  const { core, level } = stripLogPrefix("deadlock detected");
  expect(core).toBe("deadlock detected");
  expect(level).toBeUndefined();
});

test("drops a leading timestamp/pid run when no LEVEL marker exists", () => {
  const { core, level } = stripLogPrefix(
    "2024-01-01 12:00:00.123 UTC [1234] checkpoint complete",
  );
  expect(core).toBe("checkpoint complete");
  expect(level).toBeUndefined();
});

test("the LAST level marker wins", () => {
  const { core, level } = stripLogPrefix(
    "LOG:  duration: 1 ms  ERROR:  it broke",
  );
  expect(core).toBe("it broke");
  expect(level).toBe("ERROR");
});
