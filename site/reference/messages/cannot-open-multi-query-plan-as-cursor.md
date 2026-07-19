---
message: "cannot open multi-query plan as cursor"
slug: cannot-open-multi-query-plan-as-cursor
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_DEFINITION
    code: "42P11"
call_sites:
  - "postgres/src/backend/executor/spi.c:1601"
reproduced: false
---

# `cannot open multi-query plan as cursor`

## What it means

SPI was asked to open a cursor over a prepared plan that contains more than one query. A cursor returns rows from a single query, so a plan holding several commands cannot back one.

## When it happens

It occurs when procedural code (PL/pgSQL or an extension using SPI) prepares a statement string with multiple commands and then tries to open it as a cursor.

## How to fix

Prepare a single query per plan you intend to open as a cursor. Split the statement so the cursor is defined over one `SELECT` (or other row-returning command).

## Example

*Illustrative* — a cursor over a multi-command plan.

```text
ERROR:  cannot open multi-query plan as cursor
```

## Related

- [cannot open query as cursor](./cannot-open-query-as-cursor.md)
- [cannot insert multiple commands into a prepared statement](./cannot-insert-multiple-commands-into-a-prepared-statement.md)
