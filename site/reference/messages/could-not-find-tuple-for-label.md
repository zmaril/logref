---
message: "could not find tuple for label %u"
slug: could-not-find-tuple-for-label
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4155"
reproduced: false
---

# `could not find tuple for label %u`

## What it means

Object-address code looked up the catalog row for an enum label by its identifier and did not find it. Resolving an enum value to a readable name needs the `pg_enum` row for that label.

## When it happens

It fires while turning an object reference into text (for dependency reports, error detail, or `pg_describe_object`), when the enum label was dropped or the catalog row is missing.

## How to fix

This is an internal guard. It usually means an enum value was removed while something still referred to it. Make sure enum types are not being altered concurrently with the operation that failed. On stable definitions, capture the label OID and report a reproducible case.

## Example

*Illustrative* — a missing enum-label row.

```text
ERROR:  could not find tuple for label 16512
```

## Related

- [could not find tuple for property](./could-not-find-tuple-for-property.md)
- [could not find tuple for object in catalog](./could-not-find-tuple-for-object-in-catalog.md)
