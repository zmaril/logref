---
message: "cannot inherit from partitioned table \"%s\""
slug: cannot-inherit-from-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2751"
  - "postgres/src/backend/commands/tablecmds.c:18010"
reproduced: false
---

# `cannot inherit from partitioned table "%s"`

## What it means

A `CREATE TABLE ... INHERITS` or `ALTER TABLE ... INHERIT` named a partitioned table as a parent. The placeholder is the parent name. Partitioned tables use the partitioning system, not legacy table inheritance, and cannot be inherited from with `INHERITS`.

## When it happens

Trying to build a classic inheritance child under a partitioned parent, or mixing the older `INHERITS` mechanism with declarative partitioning.

## How to fix

Attach the table as a partition with `CREATE TABLE ... PARTITION OF` or `ALTER TABLE ... ATTACH PARTITION` instead of using `INHERITS`. Declarative partitioning replaces inheritance for partitioned tables.

## Example

*Illustrative* — inheriting from a partitioned table.

```sql
CREATE TABLE child () INHERITS (parted);
-- ERROR:  cannot inherit from partitioned table "parted"
```

## Related

- [circular inheritance not allowed](./circular-inheritance-not-allowed.md)
- [cannot create a temporary relation as partition of permanent relation](./cannot-create-a-temporary-relation-as-partition-of-permanent-relation.md)
