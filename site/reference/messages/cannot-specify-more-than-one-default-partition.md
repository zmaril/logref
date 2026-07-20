---
message: "cannot specify more than one DEFAULT partition"
slug: cannot-specify-more-than-one-default-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3619"
reproduced: false
---

# `cannot specify more than one DEFAULT partition`

## What it means

A partitioned table was given two `DEFAULT` partitions. Each partitioned table can have at most one default partition, which catches rows that match no other partition, so a second one is rejected.

## When it happens

It occurs when `CREATE TABLE ... PARTITION OF ... DEFAULT` or `ALTER TABLE ... ATTACH PARTITION ... DEFAULT` is run for a table that already has a default partition.

## How to fix

Remove or detach the existing default partition before adding a new one, or attach the new partition with explicit bounds instead of `DEFAULT`.

## Example

*Illustrative* — a second default partition.

```sql
CREATE TABLE p2 PARTITION OF t DEFAULT;
-- ERROR:  cannot specify more than one DEFAULT partition
```

## Related

- [cannot split partition only to add a DEFAULT partition](./cannot-split-partition-only-to-add-a-default-partition.md)
- [cannot specify NULL in range bound](./cannot-specify-null-in-range-bound.md)
