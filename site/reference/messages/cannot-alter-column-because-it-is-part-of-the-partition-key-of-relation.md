---
message: "cannot alter column \"%s\" because it is part of the partition key of relation \"%s\""
slug: cannot-alter-column-because-it-is-part-of-the-partition-key-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14983"
reproduced: false
---

# `cannot alter column "%s" because it is part of the partition key of relation "%s"`

## What it means

An `ALTER TABLE` tried to change a column that participates in the table's partition key. The placeholders name the column and relation. Partition-key columns cannot be altered in ways that would invalidate how rows are routed.

## When it happens

It occurs when altering the type, or otherwise modifying, a column that is part of a `PARTITION BY` key.

## How to fix

Avoid altering partition-key columns. If the change is essential, it typically requires rebuilding the partitioned table with a new partition key: create a new partitioned table, migrate the data, and swap it in.

## Example

*Illustrative* — altering a partition-key column.

```sql
ALTER TABLE measurement ALTER COLUMN logdate TYPE text;
```

## Related

- [cannot alter inherited column](./cannot-alter-inherited-column.md)
- [cannot alter column type of typed table](./cannot-alter-column-type-of-typed-table.md)
