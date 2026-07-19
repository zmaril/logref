---
message: "could not find tuple for statistics object %u"
slug: could-not-find-tuple-for-statistics-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3581"
reproduced: false
---

# `could not find tuple for statistics object %u`

## What it means

Object-address code looked up an extended-statistics object's catalog row by its identifier and did not find it. It needs the `pg_statistic_ext` row to describe the statistics object.

## When it happens

It fires while resolving a reference to an extended-statistics object (created with `CREATE STATISTICS`), when that object was dropped concurrently or the catalog is inconsistent.

## How to fix

This is an internal guard. Confirm the statistics object still exists and is not being dropped concurrently. On stable definitions, capture the identifier and report a reproducible case.

## Example

*Illustrative* — a missing extended-statistics row.

```text
ERROR:  could not find tuple for statistics object 16810
```

## Related

- [could not find suitable unique index on materialized view](./could-not-find-suitable-unique-index-on-materialized-view.md)
- [could not find tuple for object in catalog](./could-not-find-tuple-for-object-in-catalog.md)
