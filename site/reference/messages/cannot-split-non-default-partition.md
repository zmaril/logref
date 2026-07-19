---
message: "cannot split non-DEFAULT partition \"%s\""
slug: cannot-split-non-default-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3662"
reproduced: false
---

# `cannot split non-DEFAULT partition "%s"`

## What it means

A `SPLIT PARTITION` command produced new partitions that do not cover the same values as the partition being split, in a context that required the split to add a default. The split of a non-default partition must fully cover the original range or list of values.

## When it happens

It occurs with `ALTER TABLE ... SPLIT PARTITION`, when the resulting partitions leave a gap and the command tries to add a default partition to fill it.

## How to fix

Make the new partitions cover exactly the values the split partition held, so no default is needed. Adjust the new bounds or lists to leave no gap.

## Example

*Illustrative* — an incomplete split of a non-default partition.

```sql
ALTER TABLE t SPLIT PARTITION t_p1 INTO (...);
-- ERROR:  cannot split non-DEFAULT partition "t_p1"
```

## Related

- [cannot split DEFAULT partition](./cannot-split-default-partition.md)
- [cannot split to partition together with partition](./cannot-split-to-partition-together-with-partition.md)
