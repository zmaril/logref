---
message: "modulus for hash partition must be an integer value greater than zero"
slug: modulus-for-hash-partition-must-be-an-integer-value-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4883"
  - "postgres/src/backend/partitioning/partbounds.c:4793"
reproduced: true
---

# `modulus for hash partition must be an integer value greater than zero`

## What it means

A `FOR VALUES WITH (MODULUS m, REMAINDER r)` hash-partition bound used a modulus that is zero or negative. The modulus must be a positive integer.

## When it happens

It arises from `CREATE TABLE ... PARTITION OF ... FOR VALUES WITH (MODULUS m, REMAINDER r)` when `m` is not greater than zero.

## How to fix

Use a positive integer modulus, and make sure each remainder is in `0..m-1`. Across a hash-partitioned table the moduli must be consistent so the partitions tile the hash space without gaps or overlaps.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
CREATE TABLE s36.hp0 PARTITION OF s36.hp FOR VALUES WITH (MODULUS 0, REMAINDER 0);
```

Produces:

```text
ERROR:  modulus for hash partition must be an integer value greater than zero
```

## Related

- [number of partitioning columns does not match number of partition keys provided](./number-of-partitioning-columns-does-not-match-number-of-partition-keys-provided.md)
- [must be >= 0](./must-be-0.md)
