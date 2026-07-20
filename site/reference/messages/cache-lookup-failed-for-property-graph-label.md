---
message: "cache lookup failed for property graph label %u"
slug: cache-lookup-failed-for-property-graph-label
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:6207"
reproduced: false
---

# `cache lookup failed for property graph label %u`

## What it means

An internal lookup for a property-graph label by OID found no matching row. The placeholder is the OID. A label belonging to a property graph is missing from the catalog.

## When it happens

It usually reflects a race with a concurrent drop of the property graph or its label, or a catalog inconsistency.

## How to fix

Retry if concurrent DDL was in progress. If it recurs, investigate the property-graph catalogs for consistency and consider a restore from backup.

## Example

*Illustrative* — a missing graph label.

```text
ERROR:  cache lookup failed for property graph label 16460
```

## Related

- [cache lookup failed for property graph property](./cache-lookup-failed-for-property-graph-property.md)
- [cache lookup failed for label](./cache-lookup-failed-for-label.md)
