---
message: "cannot split partition \"%s\" only to add a DEFAULT partition"
slug: cannot-split-partition-only-to-add-a-default-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:5846"
reproduced: false
---

# `cannot split partition "%s" only to add a DEFAULT partition`

## What it means

A `SPLIT PARTITION` command listed only a single resulting partition and that partition was a default. Splitting must divide the original into distinct pieces, so producing just one default partition is not a valid split.

## When it happens

It occurs with `ALTER TABLE ... SPLIT PARTITION ... INTO (...)` when the `INTO` list resolves to a lone default partition.

## How to fix

List two or more resulting partitions, or resulting partitions with explicit bounds that carve up the original. If you only want a default, detach the partition instead of splitting it.

## Example

*Illustrative* — a split that yields only a default.

```sql
ALTER TABLE t SPLIT PARTITION t_p1 INTO (PARTITION d DEFAULT);
-- ERROR:  cannot split partition "t_p1" only to add a DEFAULT partition
```

## Related

- [cannot specify more than one DEFAULT partition](./cannot-specify-more-than-one-default-partition.md)
- [cannot split DEFAULT partition](./cannot-split-default-partition.md)
