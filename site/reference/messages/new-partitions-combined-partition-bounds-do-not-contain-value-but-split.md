---
message: "new partitions' combined partition bounds do not contain value (%s) but split partition \"%s\" does"
slug: new-partitions-combined-partition-bounds-do-not-contain-value-but-split
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:5662"
  - "postgres/src/backend/partitioning/partbounds.c:5705"
reproduced: false
---

# `new partitions' combined partition bounds do not contain value (%s) but split partition "%s" does`

## What it means

A `SPLIT PARTITION` command produced new partitions whose combined bounds do not cover a value that the partition being split does cover. Splitting must not lose any values from the original partition's range. The placeholders show the uncovered value and the partition name.

## When it happens

It arises from `ALTER TABLE ... SPLIT PARTITION` when the new partition bounds leave a gap, so some value accepted by the original partition would belong to none of the new ones.

## How to fix

Define the new partitions so their bounds together exactly cover the original partition's range with no gaps or overlaps. Adjust the split boundaries so every value the source partition held maps into one of the new partitions.

## Example

*Illustrative* — split partitions leaving a gap.

```sql
ALTER TABLE t SPLIT PARTITION p INTO (...);  -- new bounds miss a value p covered
```

## Related

- [number of partitioning columns does not match number of partition keys provided](./number-of-partitioning-columns-does-not-match-number-of-partition-keys-provided.md)
- [modulus for hash partition must be an integer value greater than zero](./modulus-for-hash-partition-must-be-an-integer-value-greater-than-zero.md)
