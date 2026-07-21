---
message: "cannot alter inherited column \"%s\""
slug: cannot-alter-inherited-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14974"
reproduced: true
---

# `cannot alter inherited column "%s"`

## What it means

An `ALTER TABLE` tried to change a column that a child table inherits from a parent. The placeholder is the column. Inherited columns are defined on the parent, so they cannot be altered on the child independently.

## When it happens

It occurs when running an `ALTER TABLE ... ALTER COLUMN` on a child or partition for a column that comes from the parent.

## How to fix

Alter the column on the parent table, and the change flows to the children. Inherited columns must stay consistent across the hierarchy, so they are managed from the parent.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER TABLE s37.ic ALTER COLUMN a TYPE bigint;
```

Produces:

```text
ERROR:  cannot alter inherited column "a"
```

## Related

- [cannot alter inherited column of relation](./cannot-alter-inherited-column-of-relation.md)
- [cannot alter column because it is part of the partition key of relation](./cannot-alter-column-because-it-is-part-of-the-partition-key-of-relation.md)
