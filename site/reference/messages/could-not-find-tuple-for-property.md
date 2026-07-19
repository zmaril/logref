---
message: "could not find tuple for property %u"
slug: could-not-find-tuple-for-property
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4213"
reproduced: false
---

# `could not find tuple for property %u`

## What it means

Object-address code looked up an enum label's catalog row while resolving a property reference and did not find it. It needs the row to render the value as text.

## When it happens

It fires while describing an object that carries an enum-valued property, when the underlying label row is missing — usually an enum value dropped while something still referenced it.

## How to fix

This is an internal guard. Make sure enum types are not altered concurrently with the operation that reported the property. On stable definitions, capture the identifier and report a reproducible case.

## Example

*Illustrative* — a missing property row.

```text
ERROR:  could not find tuple for property 16540
```

## Related

- [could not find tuple for label](./could-not-find-tuple-for-label.md)
- [could not find tuple for object in catalog](./could-not-find-tuple-for-object-in-catalog.md)
