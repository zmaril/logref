---
message: "child table \"%s\" has different definition for check constraint \"%s\""
slug: child-table-has-different-definition-for-check-constraint
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13033"
  - "postgres/src/backend/commands/tablecmds.c:18436"
reproduced: false
---

# `child table "%s" has different definition for check constraint "%s"`

## What it means

A child table's `CHECK` constraint of the same name has a different expression than the parent's. The placeholders are the child table and the constraint name. Inherited check constraints must match by definition, not only by name, across the hierarchy.

## When it happens

Attaching a partition or creating an inheritance child whose check constraint shares a name with the parent's but expresses a different condition.

## How to fix

Make the child's check constraint expression identical to the parent's, or rename one so they are distinct constraints. For partitioning, ensure matching constraints line up exactly before `ATTACH PARTITION`.

## Example

*Illustrative* — divergent check definitions.

```text
ERROR:  child table "c" has different definition for check constraint "chk"
```

## Related

- [child table has different collation for column](./child-table-has-different-collation-for-column.md)
- [check constraint of relation is violated by some row](./check-constraint-of-relation-is-violated-by-some-row.md)
