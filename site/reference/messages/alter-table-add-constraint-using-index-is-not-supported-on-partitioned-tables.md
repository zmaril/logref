---
message: "ALTER TABLE / ADD CONSTRAINT USING INDEX is not supported on partitioned tables"
slug: alter-table-add-constraint-using-index-is-not-supported-on-partitioned-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9861"
reproduced: false
---

# `ALTER TABLE / ADD CONSTRAINT USING INDEX is not supported on partitioned tables`

## What it means

An `ALTER TABLE ... ADD CONSTRAINT ... USING INDEX` was run against a partitioned table, which does not support promoting an existing index into a constraint this way.

## When it happens

It occurs when trying to attach a primary-key or unique constraint to a partitioned table by pointing at an existing index, rather than letting the server build the constraint across partitions.

## How to fix

Add the constraint directly with `ALTER TABLE ... ADD PRIMARY KEY (...)` or `ADD UNIQUE (...)` on the partitioned table, letting Postgres create the supporting indexes on each partition. The `USING INDEX` form is only for ordinary tables.

## Example

*Illustrative* — USING INDEX on a partitioned table.

```sql
ALTER TABLE parted ADD CONSTRAINT pk PRIMARY KEY USING INDEX idx;  -- not supported here
```

## Related

- [a hash-partitioned table may not have a default partition](./a-hash-partitioned-table-may-not-have-a-default-partition.md)
- [alter table / drop expression must be applied to child tables too](./alter-table-drop-expression-must-be-applied-to-child-tables-too.md)
