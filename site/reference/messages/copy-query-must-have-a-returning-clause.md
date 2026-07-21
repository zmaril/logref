---
message: "COPY query must have a RETURNING clause"
slug: copy-query-must-have-a-returning-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:983"
reproduced: false
---

# `COPY query must have a RETURNING clause`

## What it means

A `COPY (data-modifying query) TO ...` used an `INSERT`/`UPDATE`/`DELETE`/`MERGE` without a `RETURNING` clause. `COPY` needs rows to output, so a data-modifying query must return them via `RETURNING`.

## When it happens

It happens on `COPY (INSERT ...) TO ...` (or `UPDATE`/`DELETE`/`MERGE`) when the query has no `RETURNING`.

## How to fix

Add a `RETURNING` clause to the data-modifying statement so `COPY` has rows to write, or use a plain `SELECT` if you only need to read data.

## Example

*Illustrative* — COPY over a data-modifying query without RETURNING.

```sql
COPY (DELETE FROM t WHERE a < 0) TO STDOUT;
-- ERROR:  COPY query must have a RETURNING clause
```

## Related

- [COPY query must not be a utility command](./copy-query-must-not-be-a-utility-command.md)
- [COPY (SELECT INTO) is not supported](./copy-select-into-is-not-supported.md)
