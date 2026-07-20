---
message: "cache lookup failed for operator class %u"
slug: cache-lookup-failed-for-operator-class
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/bloom/blvalidate.c:50"
  - "postgres/src/backend/access/brin/brin_validate.c:58"
  - "postgres/src/backend/access/gin/ginvalidate.c:51"
  - "postgres/src/backend/access/gist/gistvalidate.c:52"
  - "postgres/src/backend/access/hash/hashvalidate.c:60"
  - "postgres/src/backend/access/index/amapi.c:198"
  - "postgres/src/backend/access/nbtree/nbtvalidate.c:61"
  - "postgres/src/backend/access/spgist/spgvalidate.c:63"
  - "postgres/src/backend/catalog/index.c:842"
reproduced: false
---

# `cache lookup failed for operator class %u`

## What it means

Internal error. An operator class's catalog row (`pg_opclass`) could not be found by OID — the same underlying failure as the shorter "opclass" form, phrased in full. The placeholder is the OID. Something referenced the operator class but the row is gone.

## When it happens

A concurrent drop of an operator class still referenced by an index, catalog inconsistency, or an extension holding the OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs, inspect `pg_opclass`; a missing row is corruption. Custom access-method/opclass extensions are the usual source when torn down while in use — verify their scripts. Report reproducible cases.

## Example

*Illustrative* — an operator class dropped while indexed.

```text
ERROR:  cache lookup failed for operator class 16770
```

## Related

- [cache lookup failed for opclass](./cache-lookup-failed-for-opclass.md)
- [missing operator in opfamily](./missing-operator-in-opfamily.md)
