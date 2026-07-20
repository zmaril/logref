---
message: "could not find tuple for column %d of relation %u"
slug: could-not-find-tuple-for-column-of-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/relation.c:84"
reproduced: false
---

# `could not find tuple for column %d of relation %u`

## What it means

The SELinux support module (`sepgsql`) looked up the catalog row describing a specific column of a relation and did not find it. It needs that row to derive the column's security label.

## When it happens

It fires inside `sepgsql` while labeling or checking a column, when the `pg_attribute` row it expects is missing — typically because the column was dropped concurrently or the catalog is inconsistent.

## How to fix

This is an internal guard in the `sepgsql` extension. Make sure the object still exists and is not being altered concurrently. If it recurs on stable schema, the catalog may be damaged; note the column number and relation OID and report a reproducible case.

## Example

*Illustrative* — a missing attribute row during a label lookup.

```text
ERROR:  could not find tuple for column 3 of relation 16408
```

## Related

- [could not find tuple for object in catalog](./could-not-find-tuple-for-object-in-catalog.md)
- [could not find tuple for namespace](./could-not-find-tuple-for-namespace.md)
