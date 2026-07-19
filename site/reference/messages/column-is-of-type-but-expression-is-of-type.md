---
message: "column \"%s\" is of type %s but expression is of type %s"
slug: column-is-of-type-but-expression-is-of-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:593"
reproduced: false
---

# `column "%s" is of type %s but expression is of type %s`

## What it means

An assignment (in `INSERT`, `UPDATE`, or a similar target list) supplied a value whose type does not match the target column, and no implicit cast exists to convert it. Postgres will not silently coerce between unrelated types.

## When it happens

It happens when the value written to a column is of a type that cannot be implicitly cast to the column's declared type, for example inserting `text` into an `integer` column without a cast.

## How to fix

Cast the expression to the column's type explicitly with `expr::coltype` or `CAST(expr AS coltype)`, or correct the source value so its type already matches. Check that column and value line up in the statement.

## Example

*Illustrative* — a type mismatch without an implicit cast.

```sql
CREATE TABLE t (n integer);
INSERT INTO t (n) VALUES (ARRAY[1,2]);
-- ERROR:  column "n" is of type integer but expression is of type integer[]
```

## Related

- [column cannot be cast automatically to type](./column-cannot-be-cast-automatically-to-type.md)
- [column has a type conflict](./column-has-a-type-conflict.md)
