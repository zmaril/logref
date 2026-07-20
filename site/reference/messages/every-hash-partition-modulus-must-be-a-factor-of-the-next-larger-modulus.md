---
message: "every hash partition modulus must be a factor of the next larger modulus"
slug: every-hash-partition-modulus-must-be-a-factor-of-the-next-larger-modulus
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:2963"
  - "postgres/src/backend/partitioning/partbounds.c:2982"
  - "postgres/src/backend/partitioning/partbounds.c:3004"
reproduced: false
---

# `every hash partition modulus must be a factor of the next larger modulus`

## What it means

A hash partition was defined with a modulus that does not fit the existing set: each hash partition's modulus must divide evenly into every larger modulus among the partitions. This rule lets hash partitioning be built up incrementally while keeping the row-to-partition mapping consistent.

## When it happens

Adding a hash partition `FOR VALUES WITH (MODULUS m, REMAINDER r)` where `m` is not a factor of (or multiple relationship with) the moduli already in use — for example mixing modulus 4 and modulus 6 partitions.

## How to fix

Choose moduli with a divides-evenly relationship. A common approach is powers of two (4, 8, 16) or a single fixed modulus for all partitions; when splitting later, the new modulus must be a multiple of the smaller ones. Plan the modulus scheme so every value divides into the larger ones.

## Example

*Illustrative* — an incompatible hash modulus.

```text
ERROR:  every hash partition modulus must be a factor of the next larger modulus
```

## Related

- [partition with name is already used](./partition-with-name-is-already-used.md)
- [cannot specify default tablespace for partitioned relations](./cannot-specify-default-tablespace-for-partitioned-relations.md)
