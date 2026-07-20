---
message: "cache lookup failed for property graph property %u"
slug: cache-lookup-failed-for-property-graph-property
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:6229"
reproduced: false
---

# `cache lookup failed for property graph property %u`

## What it means

An internal lookup for a property-graph property by OID found no matching row. The placeholder is the OID. A property belonging to a property graph is missing from the catalog.

## When it happens

It usually reflects a race with a concurrent drop of the property graph or its property, or a catalog inconsistency.

## How to fix

Retry if concurrent DDL was involved. If it recurs, investigate the property-graph catalogs for consistency and consider a restore from backup.

## Example

*Illustrative* — a missing graph property.

```text
ERROR:  cache lookup failed for property graph property 16470
```

## Related

- [cache lookup failed for property graph label](./cache-lookup-failed-for-property-graph-label.md)
- [cache lookup failed for property](./cache-lookup-failed-for-property.md)
