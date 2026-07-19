---
message: "number of partitioning columns (%d) does not match number of partition keys provided (%d)"
slug: number-of-partitioning-columns-does-not-match-number-of-partition-keys-provided
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:4832"
  - "postgres/src/backend/partitioning/partbounds.c:4961"
reproduced: false
---

# `number of partitioning columns (%d) does not match number of partition keys provided (%d)`

## What it means

A partition bound or key operation supplied a different number of key values than the table's partition key has columns. The placeholders show the two counts. They must match.

## When it happens

It arises in partition DDL — for example a `FOR VALUES` clause or partition-key handling — when the number of values given does not equal the number of columns in the partition key.

## How to fix

Provide exactly one value per partition-key column, in key order. Check the partitioned table's key with `\d+ parent` and align the count of values in the bound to the number of key columns.

## Example

*Illustrative* — mismatched key value count.

```text
ERROR:  number of partitioning columns (2) does not match number of partition keys provided (1)
```

## Related

- [modulus for hash partition must be an integer value greater than zero](./modulus-for-hash-partition-must-be-an-integer-value-greater-than-zero.md)
- [new partitions' combined partition bounds do not contain value but split](./new-partitions-combined-partition-bounds-do-not-contain-value-but-split.md)
