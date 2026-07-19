---
message: "child table is missing constraint \"%s\""
slug: child-table-is-missing-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18516"
reproduced: false
---

# `child table is missing constraint "%s"`

## What it means

An inheritance or partition operation found that a child table lacks a `CHECK` constraint its parent defines. A child must carry all of the parent's check constraints, so the missing one blocks the operation.

## When it happens

It occurs on `ALTER TABLE ... INHERIT` or `ATTACH PARTITION` when the parent has a check constraint the child does not.

## How to fix

Add the matching check constraint to the child, then retry. Define the constraint on the child with the same condition as the parent's before joining the hierarchy.

## Example

*Illustrative* — a child missing a parent constraint.

```text
ERROR:  child table is missing constraint "c"
```

## Related

- [child table is missing column](./child-table-is-missing-column.md)
- [check constraint already exists](./check-constraint-already-exists.md)
