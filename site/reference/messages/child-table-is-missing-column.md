---
message: "child table is missing column \"%s\""
slug: child-table-is-missing-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18319"
reproduced: false
---

# `child table is missing column "%s"`

## What it means

An inheritance or partition operation found that a child table does not have a column its parent requires. Every child must contain all of the parent's columns with matching types, so the missing column blocks the operation.

## When it happens

It occurs on `ALTER TABLE ... INHERIT` or `ATTACH PARTITION` when the child lacks a column present in the parent.

## How to fix

Add the missing column to the child with the same name and a compatible type, then retry the inherit or attach. Align the child's shape with the parent before joining the hierarchy.

## Example

*Illustrative* — a child missing a parent column.

```text
ERROR:  child table is missing column "c"
```

## Related

- [child table is missing constraint](./child-table-is-missing-constraint.md)
- [column cannot be cast automatically to type](./column-cannot-be-cast-automatically-to-type.md)
