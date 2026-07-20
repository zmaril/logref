---
message: "cannot split to partition \"%s\" together with partition \"%s\""
slug: cannot-split-to-partition-together-with-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:5052"
reproduced: false
---

# `cannot split to partition "%s" together with partition "%s"`

## What it means

A `SPLIT PARTITION` command listed the same partition name twice among its results, or named a resulting partition that collides with an existing one. Each resulting partition must have a distinct name.

## When it happens

It occurs with `ALTER TABLE ... SPLIT PARTITION ... INTO (...)` when two of the new partitions carry the same name.

## How to fix

Give every resulting partition a unique name. Rename the duplicated entry in the `INTO` list and rerun.

## Example

*Illustrative* — a duplicate name in a split.

```sql
ALTER TABLE t SPLIT PARTITION t_p1 INTO (PARTITION a ..., PARTITION a ...);
-- ERROR:  cannot split to partition "a" together with partition "a"
```

## Related

- [cannot split non-DEFAULT partition](./cannot-split-non-default-partition.md)
- [cannot split partition only to add a DEFAULT partition](./cannot-split-partition-only-to-add-a-default-partition.md)
