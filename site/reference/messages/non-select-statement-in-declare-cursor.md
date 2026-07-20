---
message: "non-SELECT statement in DECLARE CURSOR"
slug: non-select-statement-in-declare-cursor
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/portalcmds.c:94"
  - "postgres/src/backend/commands/portalcmds.c:99"
reproduced: false
---

# `non-SELECT statement in DECLARE CURSOR`

## What it means

A `DECLARE CURSOR` was given a statement that is not a `SELECT` (or `VALUES`). Cursors iterate over query results, so the command must be a query.

## When it happens

It arises when declaring a cursor over a data-modifying or utility statement — for example `DECLARE c CURSOR FOR UPDATE ...` — rather than a query.

## How to fix

Declare cursors only over `SELECT` or `VALUES` queries. If you need to iterate the results of a data-modifying statement, add a `RETURNING` clause and use it within a query context, or restructure the logic.

## Example

*Illustrative* — a cursor over a non-SELECT statement.

```sql
DECLARE c CURSOR FOR UPDATE t SET x = 1;  -- must be a query
```

## Related

- [into used with a command that cannot return data](./into-used-with-a-command-that-cannot-return-data.md)
- [open cursor failed during argument processing](./open-cursor-failed-during-argument-processing.md)
