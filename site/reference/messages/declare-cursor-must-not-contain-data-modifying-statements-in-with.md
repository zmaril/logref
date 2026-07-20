---
message: "DECLARE CURSOR must not contain data-modifying statements in WITH"
slug: declare-cursor-must-not-contain-data-modifying-statements-in-with
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3404"
reproduced: false
---

# `DECLARE CURSOR must not contain data-modifying statements in WITH`

## What it means

A `DECLARE CURSOR` statement contained a data-modifying statement inside its `WITH` clause — an `INSERT`, `UPDATE`, `DELETE`, or `MERGE`. Cursors scan a read-only result, so writing CTEs are not allowed in them. The server reports it as an unsupported feature.

## When it happens

It happens when you declare a cursor over a query whose `WITH` clause includes a data-modifying CTE.

## How to fix

Remove the data-modifying statement from the cursor's query, or run it separately before opening the cursor. A cursor must scan a plain read-only query; perform any writes outside the cursor declaration.

## Example

*Illustrative* — a writing CTE in a cursor.

```sql
DECLARE c CURSOR FOR WITH d AS (DELETE FROM t RETURNING *) SELECT * FROM d;
-- ERROR:  DECLARE CURSOR must not contain data-modifying statements in WITH
```

## Related

- [DECLARE CURSOR WITH HOLD is not supported](./declare-cursor-with-hold-is-not-supported.md)
- [cursor is not a SELECT query](./cursor-is-not-a-select-query.md)
