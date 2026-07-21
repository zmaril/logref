---
message: "cache lookup failed for partition key of relation %u"
slug: cache-lookup-failed-for-partition-key-of-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/heap.c:4052"
  - "postgres/src/backend/catalog/partition.c:351"
  - "postgres/src/backend/utils/cache/partcache.c:98"
reproduced: false
---

# `cache lookup failed for partition key of relation %u`

## What it means

Internal error. The partition-key catalog row (`pg_partitioned_table`) for a partitioned relation could not be found by OID. The placeholder is the relation OID. Code treated the relation as partitioned and expected its partition-key entry, which was missing.

## When it happens

A concurrent drop of the partitioned table, or catalog inconsistency between `pg_class` and `pg_partitioned_table`. Not caused by ordinary data.

## How to fix

If concurrent DDL dropped the table, retry. If it recurs for one OID, inspect `pg_partitioned_table`; a missing partition-key row for a relation still marked partitioned indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a partition key row not found.

```text
ERROR:  cache lookup failed for partition key of relation 16700
```

## Related

- [every hash partition modulus must be a factor of the next larger modulus](./every-hash-partition-modulus-must-be-a-factor-of-the-next-larger-modulus.md)
- [cannot specify default tablespace for partitioned relations](./cannot-specify-default-tablespace-for-partitioned-relations.md)
