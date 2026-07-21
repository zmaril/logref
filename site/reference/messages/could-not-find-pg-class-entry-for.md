---
message: "could not find pg_class entry for %u"
slug: could-not-find-pg-class-entry-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:1377"
reproduced: false
---

# `could not find pg_class entry for %u`

## What it means

The relation cache could not find a `pg_class` catalog entry for a relation OID it was asked to load. The `%u` is the OID. This is an internal guard: an OID handed to the cache should refer to a real relation.

## When it happens

It fires when the relation cache builds an entry and the underlying `pg_class` row is missing, usually from a catalog inconsistency or a relation dropped concurrently.

## How to fix

This is an internal error. Check for concurrent DROP activity on the relation involved and for catalog corruption. Note the operation and report a reproducible case if the catalog is intact.

## Example

*Illustrative* — a relation OID with no pg_class row.

```text
ERROR:  could not find pg_class entry for 16400
```

## Related

- [could not find pg_class tuple for index](./could-not-find-pg-class-tuple-for-index.md)
- [could not find not-null constraint on domain](./could-not-find-not-null-constraint-on-domain.md)
