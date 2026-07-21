---
message: "canceling statement due to statement timeout"
slug: canceling-statement-due-to-statement-timeout
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_QUERY_CANCELED
    code: "57014"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3614"
reproduced: false
---

# `canceling statement due to statement timeout`

## What it means

A statement ran longer than `statement_timeout` permits, so the server canceled it. The statement-timeout setting caps how long any single statement may execute.

## When it happens

It occurs when a query's total run time exceeds `statement_timeout`, whether from a heavy query, missing indexes, lock waits, or a limit set too low for the workload.

## How to fix

Decide whether the statement or the limit is at fault. Speed up genuinely slow queries with indexing or rewriting, or raise `statement_timeout` for sessions that legitimately need longer. Set the limit per-session or per-role rather than globally when only some work needs more time.

## Example

*Illustrative* — a query exceeding the timeout.

```text
ERROR:  canceling statement due to statement timeout
```

## Related

- [canceling statement due to lock timeout](./canceling-statement-due-to-lock-timeout.md)
- [canceling statement due to user request](./canceling-statement-due-to-user-request.md)
