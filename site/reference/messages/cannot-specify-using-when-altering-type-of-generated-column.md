---
message: "cannot specify USING when altering type of generated column"
slug: cannot-specify-using-when-altering-type-of-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14962"
reproduced: false
---

# `cannot specify USING when altering type of generated column`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` on a generated column included a `USING` expression. A generated column's values come from its generation expression, so a `USING` conversion has no meaning and is rejected.

## When it happens

It occurs when changing the type of a `GENERATED ALWAYS AS (...) STORED` column and adding a `USING` clause to the `ALTER COLUMN TYPE` command.

## How to fix

Drop the `USING` clause. If the stored values need to change, alter the generation expression separately; the column recomputes from it under the new type.

## Example

*Illustrative* — USING on a generated column.

```sql
ALTER TABLE t ALTER COLUMN g TYPE bigint USING g::bigint;
-- ERROR:  cannot specify USING when altering type of generated column
```

## Related

- [cannot use generated column in column generation expression](./cannot-use-generated-column-in-column-generation-expression.md)
- [cannot use generated column in FOR PORTION OF](./cannot-use-generated-column-in-for-portion-of.md)
