---
message: "cannot use generated column \"%s\" in column generation expression"
slug: cannot-use-generated-column-in-column-generation-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3222"
reproduced: true
---

# `cannot use generated column "%s" in column generation expression`

## What it means

A generated column's expression referenced another generated column. A generation expression may read only plain stored columns of the same row, so referencing another generated column is not allowed.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE` when a `GENERATED ALWAYS AS (...)` expression uses a column that is itself generated.

## How to fix

Rewrite the expression to reference only ordinary stored columns. If you need a value derived from another generated column, inline that column's own expression instead of naming it.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
CREATE TABLE repro.gen2 (a int, b int GENERATED ALWAYS AS (a) STORED, c int GENERATED ALWAYS AS (b) STORED);
```

Produces:

```text
ERROR:  cannot use generated column "b" in column generation expression
```

## Related

- [cannot use system column in column generation expression](./cannot-use-system-column-in-column-generation-expression.md)
- [cannot specify USING when altering type of generated column](./cannot-specify-using-when-altering-type-of-generated-column.md)
