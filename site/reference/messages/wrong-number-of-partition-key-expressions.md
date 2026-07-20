---
message: "wrong number of partition key expressions"
slug: wrong-number-of-partition-key-expressions
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execPartition.c:1508"
  - "postgres/src/backend/executor/execPartition.c:1519"
  - "postgres/src/backend/optimizer/util/plancat.c:2861"
  - "postgres/src/backend/partitioning/partbounds.c:4645"
  - "postgres/src/backend/partitioning/partbounds.c:4693"
  - "postgres/src/backend/utils/cache/partcache.c:240"
reproduced: false
---

# `wrong number of partition key expressions`

## What it means

Internal error. Partition routing or bound-checking compared a set of partition-key expressions against the partitioned table's declared key and found a different count than expected. It is a consistency check between the catalog's partition key and the values being routed.

## When it happens

It should not occur for normally-created partitioned tables. Reaching it points to catalog inconsistency or a bug in partitioning code, not to your SQL.

## How to fix

Treat it as an internal bug. If it recurs, inspect the partitioned table's key in `pg_partitioned_table`; a mismatch there indicates corruption. Capture the table definition and the failing statement and report it.

## Example

*Illustrative* — emitted internally during partition routing.

```text
ERROR:  wrong number of partition key expressions
```

## Related

- [unexpected partition strategy](./unexpected-partition-strategy.md)
- [default expression not found for attribute of relation](./default-expression-not-found-for-attribute-of-relation.md)
