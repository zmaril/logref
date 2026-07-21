---
message: "unknown attrKind %u"
slug: unknown-attrkind
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:5343"
  - "postgres/src/backend/utils/cache/relcache.c:5565"
reproduced: false
---

# `unknown attrKind %u`

## What it means

Internal error. Catalog code building or reading a column descriptor met an attribute-kind value it does not recognize.

## When it happens

It fires where the kind of a table column or composite attribute is switched on and the value is outside the known set. Normal catalogs do not produce it.

## How to fix

This is an internal guard over catalog metadata. If routine DDL or a query reaches it, the catalog row may be inconsistent; capture the object and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized attribute kind.

```text
ERROR:  unknown attrKind 5
```

## Related

- [unknown constraint type](./unknown-constraint-type.md)
- [unexpected typLen: %d](./unexpected-typlen.md)
