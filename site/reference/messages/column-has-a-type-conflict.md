---
message: "column \"%s\" has a type conflict"
slug: column-has-a-type-conflict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3353"
reproduced: false
---

# `column "%s" has a type conflict`

## What it means

A table column inherits from more than one parent, and those parents give the column incompatible data types. The inheriting table cannot merge the definitions into a single column, so the command is rejected.

## When it happens

It happens during `CREATE TABLE ... INHERITS` (or when a partition or child table draws a column from multiple parents) when the same column name arrives with different types from the parents being combined.

## How to fix

Make the column's type agree across every parent. Alter the parents so the shared column has one common type, or drop the conflicting column from all but one parent before creating the child.

## Example

*Illustrative* — a column inherited with two different types.

```sql
CREATE TABLE a (x integer);
CREATE TABLE b (x text);
CREATE TABLE c () INHERITS (a, b);
-- ERROR:  column "x" has a type conflict
```

## Related

- [column has a storage parameter conflict](./column-has-a-storage-parameter-conflict.md)
- [column inherits conflicting default values](./column-inherits-conflicting-default-values.md)
