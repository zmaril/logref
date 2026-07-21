---
message: "cannot open %s query as cursor"
slug: cannot-open-query-as-cursor
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_DEFINITION
    code: "42P11"
call_sites:
  - "postgres/src/backend/executor/spi.c:1610"
reproduced: false
---

# `cannot open %s query as cursor`

## What it means

SPI was asked to open a cursor over a command that does not return rows. Only row-returning queries can back a cursor, and the named command type does not. The placeholder is the command type.

## When it happens

It occurs when procedural code opens a cursor over a statement such as an `INSERT` without `RETURNING`, a `DDL` command, or another non-row-returning command.

## How to fix

Open a cursor only over a row-returning query — a `SELECT`, a `VALUES` list, or a data-modifying command with a `RETURNING` clause. Run other commands directly instead of through a cursor.

## Example

*Illustrative* — a cursor over a non-row-returning command.

```text
ERROR:  cannot open INSERT query as cursor
```

## Related

- [cannot open multi-query plan as cursor](./cannot-open-multi-query-plan-as-cursor.md)
- [cannot perform transaction commands inside a cursor loop that is not read-only](./cannot-perform-transaction-commands-inside-a-cursor-loop-that-is-not-read-only.md)
