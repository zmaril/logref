---
message: "not-null constraints on partitioned tables cannot be NO INHERIT"
slug: not-null-constraints-on-partitioned-tables-cannot-be-no-inherit
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:755"
  - "postgres/src/backend/parser/parse_utilcmd.c:1073"
reproduced: false
---

# `not-null constraints on partitioned tables cannot be NO INHERIT`

## What it means

A `NOT NULL` constraint on a partitioned table was declared `NO INHERIT`. On partitioned tables, `NOT NULL` constraints must apply to partitions too, so `NO INHERIT` is not allowed.

## When it happens

It arises from `CREATE TABLE ... PARTITION BY ...` or `ALTER TABLE` on a partitioned table when a `NOT NULL` (or check-style not-null) constraint is marked `NO INHERIT`.

## How to fix

Remove `NO INHERIT` from the `NOT NULL` constraint on the partitioned table. Partitioned tables require their not-null constraints to be inherited by all partitions; define the constraint without `NO INHERIT`.

## Example

*Illustrative* — a NO INHERIT not-null on a partitioned table.

```sql
ALTER TABLE parted ADD CONSTRAINT c NOT NULL x NO INHERIT;  -- not allowed
```

## Related

- [is a partitioned table](./is-a-partitioned-table.md)
- [invalid action for foreign key constraint containing generated column](./invalid-action-for-foreign-key-constraint-containing-generated-column.md)
