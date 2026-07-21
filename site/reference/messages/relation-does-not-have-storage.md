---
message: "relation \"%s\" does not have storage"
slug: relation-does-not-have-storage
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pg_freespacemap/pg_freespacemap.c:38"
  - "postgres/contrib/pg_prewarm/pg_prewarm.c:155"
  - "postgres/src/backend/utils/cache/relcache.c:3893"
reproduced: true
---

# `relation "%s" does not have storage`

## What it means

A function that inspects a relation's physical storage was pointed at a relation that has none. Views, composite types, and partitioned parents have no data file of their own, so storage-level inspection does not apply to them.

## When it happens

Calling a storage-inspection function such as those in `pg_freespacemap` or `pg_prewarm` on a view, a partitioned table's parent, or another relation kind that stores no rows itself.

## How to fix

Point the function at a relation that has physical storage — an ordinary table, an index, or an individual partition. For partitioned tables, inspect the leaf partitions rather than the parent, since only the leaves hold data.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT pg_prewarm('repro.child_v', 'buffer');
```

Produces:

```text
ERROR:  relation "child_v" does not have storage
```

## Related

- [is a view](./is-a-view.md)
- [relation is not a partition of relation](./relation-is-not-a-partition-of-relation.md)
