---
message: "could not find pg_class tuple for index %u"
slug: could-not-find-pg-class-tuple-for-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:2315"
reproduced: false
---

# `could not find pg_class tuple for index %u`

## What it means

The relation cache could not find the `pg_class` catalog tuple for an index OID. The `%u` is the OID. This is an internal guard: an index OID should map to a real `pg_class` row.

## When it happens

It fires while the relation cache loads an index's catalog information and the `pg_class` row is missing, usually from a catalog inconsistency or an index dropped concurrently.

## How to fix

This is an internal error. Check for concurrent DROP activity on the index and for catalog corruption. Note the operation and report a reproducible case if the catalog is intact.

## Example

*Illustrative* — an index OID with no pg_class tuple.

```text
ERROR:  could not find pg_class tuple for index 16400
```

## Related

- [could not find pg_class entry for](./could-not-find-pg-class-entry-for.md)
- [could not find parent table of index](./could-not-find-parent-table-of-index.md)
