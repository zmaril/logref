---
message: "cache lookup failed for partition key of %u"
slug: cache-lookup-failed-for-partition-key-of
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:2318"
reproduced: false
---

# `cache lookup failed for partition key of %u`

## What it means

An internal lookup for a relation's partition key by OID found no `pg_partitioned_table` row. The placeholder is the relation OID. The partition-key metadata expected for a partitioned table is missing.

## When it happens

It usually reflects a race with a concurrent drop of the partitioned table, or catalog inconsistency in the partitioning catalogs.

## How to fix

Retry if concurrent DDL was in progress. If it recurs, investigate consistency of the partitioning catalogs for the relation and consider a restore from backup.

## Example

*Illustrative* — missing partition-key metadata.

```text
ERROR:  cache lookup failed for partition key of 16420
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-63346c.md)
- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
