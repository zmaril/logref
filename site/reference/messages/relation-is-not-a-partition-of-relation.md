---
message: "relation \"%s\" is not a partition of relation \"%s\""
slug: relation-is-not-a-partition-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18627"
  - "postgres/src/backend/commands/tablecmds.c:18675"
  - "postgres/src/backend/parser/parse_utilcmd.c:3552"
reproduced: false
---

# `relation "%s" is not a partition of relation "%s"`

## What it means

A command named a relation as a partition of a partitioned table, but it is not attached as a partition of that table. The detach or reference operation requires an existing parent-partition relationship that does not hold here.

## When it happens

Running `ALTER TABLE ... DETACH PARTITION`, or another operation that references a partition, where the named child is not currently a partition of the named parent — a wrong name, a wrong parent, or a partition already detached.

## How to fix

Confirm the partition hierarchy with `\d+ parent` in psql, which lists the parent's partitions. Name a child that is actually attached to that parent, and check that an earlier command did not already detach it.

## Example

*Illustrative* — detaching a table that is not a partition of the parent.

```sql
ALTER TABLE measurements DETACH PARTITION unrelated;  -- not a partition of measurements
```

## Related

- [no partition of relation found for row](./no-partition-of-relation-found-for-row.md)
- [inherited relation is not a table or foreign table](./inherited-relation-is-not-a-table-or-foreign-table.md)
