---
message: "remainder for hash partition must be less than modulus"
slug: remainder-for-hash-partition-must-be-less-than-modulus
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4890"
  - "postgres/src/backend/partitioning/partbounds.c:4801"
reproduced: false
---

# `remainder for hash partition must be less than modulus`

## What it means

A hash partition bound gave a remainder that is not strictly smaller than its modulus. For `FOR VALUES WITH (MODULUS m, REMAINDER r)`, `r` must satisfy `0 <= r < m`.

## When it happens

It arises from `CREATE TABLE ... PARTITION OF ... FOR VALUES WITH (MODULUS m, REMAINDER r)` where `r >= m`.

## How to fix

Choose a remainder in the range `0` to `m-1`. Each hash partition of a given modulus uses a distinct remainder in that range; make sure the set of partitions covers the remainders you intend.

## Example

*Illustrative* — a hash partition whose remainder is not below its modulus.

```text
ERROR:  remainder for hash partition must be less than modulus
```

## Related

- [sample percentage must be between 0 and 100](./sample-percentage-must-be-between-0-and-100.md)
- [relation "%s" already exists](./relation-already-exists.md)
