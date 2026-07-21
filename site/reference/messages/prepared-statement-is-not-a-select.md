---
message: "prepared statement is not a SELECT"
slug: prepared-statement-is-not-a-select
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/prepare.c:230"
  - "postgres/src/backend/commands/prepare.c:235"
reproduced: false
---

# `prepared statement is not a SELECT`

## What it means

An operation that requires a prepared statement whose command is a `SELECT` was handed a prepared statement of a different kind. The context (such as declaring a cursor over it) only accepts a query that returns rows.

## When it happens

It arises when using a prepared statement in a place that demands a row-returning query — for example `DECLARE ... CURSOR FOR` over a prepared statement that is an `INSERT`/`UPDATE`/`DELETE`/`UTILITY` command rather than a `SELECT`.

## How to fix

Prepare a `SELECT` (or a data-modifying statement with `RETURNING`, where supported) for this use, or use the non-cursor execution path for the non-`SELECT` statement.

## Example

*Illustrative* — opening a cursor over a non-SELECT prepared statement.

```text
ERROR:  prepared statement is not a SELECT
```

## Related

- [portal "%s" does not exist](./portal-does-not-exist.md)
- [query for CALL statement is not a CallStmt](./query-for-call-statement-is-not-a-callstmt.md)
