---
message: "cannot drop inherited column \"%s\""
slug: cannot-drop-inherited-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9483"
reproduced: true
---

# `cannot drop inherited column "%s"`

## What it means

An `ALTER TABLE ... DROP COLUMN` named a column that a child table inherits from a parent. Inherited columns are defined on the parent, so they cannot be dropped from the child directly. The placeholder is the column name.

## When it happens

It occurs when dropping a column on a child table that inherits it, rather than on the parent.

## How to fix

Drop the column on the parent table, which removes it from all children, or detach the child from inheritance first. Inherited structure is managed at the parent.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.inhchild DROP COLUMN a;
```

Produces:

```text
ERROR:  cannot drop inherited column "a"
```

## Related

- [cannot drop inherited constraint of relation](./cannot-drop-inherited-constraint-of-relation.md)
- [cannot drop column from only the partitioned table when partitions exist](./cannot-drop-column-from-only-the-partitioned-table-when-partitions-exist.md)
