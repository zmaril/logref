---
message: "cannot create a temporary relation as partition of permanent relation \"%s\""
slug: cannot-create-a-temporary-relation-as-partition-of-permanent-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2788"
  - "postgres/src/backend/commands/tablecmds.c:23256"
reproduced: false
---

# `cannot create a temporary relation as partition of permanent relation "%s"`

## What it means

An `ATTACH PARTITION` or `CREATE TABLE ... PARTITION OF` tried to make a temporary table a partition of a permanent partitioned table. The placeholder is the parent table. A permanent table cannot own a partition that disappears at session end.

## When it happens

Attaching or creating a `TEMPORARY` table as a partition of a permanent partitioned parent.

## How to fix

Make the partition permanent to match its parent, or make the whole partitioned table temporary if every partition is temporary. Partition and parent must share the same persistence.

## Example

*Illustrative* — a temp partition under a permanent parent.

```sql
CREATE TEMP TABLE p1 PARTITION OF perm_parent FOR VALUES FROM (1) TO (10);
-- ERROR:  cannot create a temporary relation as partition of permanent relation "perm_parent"
```

## Related

- [cannot create temporary relation in non-temporary schema](./cannot-create-temporary-relation-in-non-temporary-schema.md)
- [cannot add temporary element table to non-temporary property graph](./cannot-add-temporary-element-table-to-non-temporary-property-graph.md)
