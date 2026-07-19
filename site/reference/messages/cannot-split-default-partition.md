---
message: "cannot split DEFAULT partition \"%s\""
slug: cannot-split-default-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3646"
reproduced: false
---

# `cannot split DEFAULT partition "%s"`

## What it means

A `SPLIT PARTITION` command named the default partition as the partition to split. The default partition holds whatever does not match other partitions, and it is not directly splittable, so the operation is rejected.

## When it happens

It occurs with `ALTER TABLE ... SPLIT PARTITION default_part INTO (...)` on a range- or list-partitioned table.

## How to fix

Split a concrete partition instead, or restructure by detaching the default partition, creating the new partitions with explicit bounds, and reattaching a fresh default if you still need one.

## Example

*Illustrative* — splitting the default partition.

```sql
ALTER TABLE t SPLIT PARTITION t_default INTO (...);
-- ERROR:  cannot split DEFAULT partition "t_default"
```

## Related

- [cannot split non-DEFAULT partition](./cannot-split-non-default-partition.md)
- [cannot split partition only to add a DEFAULT partition](./cannot-split-partition-only-to-add-a-default-partition.md)
