---
message: "DO statement returned a row"
slug: do-statement-returned-a-row
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2301"
reproduced: false
---

# `DO statement returned a row`

## What it means

An internal PL/pgSQL guard. A `DO` block's anonymous code somehow produced a result row, which a `DO` statement never returns. This is a "can't happen" consistency check.

## When it happens

It fires when executing a `DO` block if the internal execution path unexpectedly yields a tuple, indicating an internal inconsistency rather than a user mistake.

## How to fix

This is not a routine user error. `DO` blocks are meant to have no result; if a specific block reproduces it, capture the block and server version and report it to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  DO statement returned a row
```

## Related

- [DefineSavepoint: unexpected state](./definesavepoint-unexpected-state.md)
- [do_numeric_discard failed unexpectedly](./do-numeric-discard-failed-unexpectedly.md)
