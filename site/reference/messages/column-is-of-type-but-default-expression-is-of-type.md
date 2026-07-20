---
message: "column \"%s\" is of type %s but default expression is of type %s"
slug: column-is-of-type-but-default-expression-is-of-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3398"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1335"
reproduced: false
---

# `column "%s" is of type %s but default expression is of type %s`

## What it means

A column's `DEFAULT` expression produces a type that does not match, and cannot be implicitly cast to, the column's declared type. The placeholders are the column type and the default's type. Postgres will not silently coerce an incompatible default.

## When it happens

Defining or altering a column with a `DEFAULT` whose expression yields a different type — for example a text default on an integer column, or a default returning a type with no implicit cast to the column type.

## How to fix

Cast the default expression to the column's type explicitly (`DEFAULT expr::coltype`), or write a default of the correct type. Verify the type the default expression returns matches the column definition.

## Example

*Illustrative* — a text default on an integer column.

```sql
ALTER TABLE t ALTER COLUMN n SET DEFAULT 'x';
-- ERROR:  column "n" is of type integer but default expression is of type text
```

## Related

- [cannot alter type because column uses it](./cannot-alter-type-because-column-uses-it.md)
- [could not coerce expression to the RETURNING type](./could-not-coerce-expression-to-the-returning-type.md)
