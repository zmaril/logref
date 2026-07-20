---
message: "column \"%s\" has pseudo-type %s"
slug: column-has-pseudo-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/heap.c:583"
reproduced: false
---

# `column "%s" has pseudo-type %s`

## What it means

A table column was defined with a pseudo-type such as `anyelement`, `record`, `trigger`, or `internal`. Pseudo-types describe how functions behave; they are not real storable types, so a table cannot have a column of one.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE ... ADD COLUMN` when the declared type is a pseudo-type rather than a concrete data type.

## How to fix

Use a concrete data type for the column. If you meant a polymorphic function argument, that belongs in a function signature, not a table definition. Pick a real type such as `integer`, `text`, or a composite type.

## Example

*Illustrative* — a pseudo-type used as a column type.

```sql
CREATE TABLE t (c anyelement);
-- ERROR:  column "c" has pseudo-type anyelement
```

## Related

- [column has a type conflict](./column-has-a-type-conflict.md)
- [column notation applied to a non-composite type](./column-notation-applied-to-type-which-is-not-a-composite-type.md)
