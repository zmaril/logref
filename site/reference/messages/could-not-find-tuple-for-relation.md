---
message: "could not find tuple for relation %u"
slug: could-not-find-tuple-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/relation.c:272"
  - "postgres/contrib/sepgsql/relation.c:664"
  - "postgres/src/backend/catalog/index.c:1603"
  - "postgres/src/backend/catalog/index.c:1607"
  - "postgres/src/backend/catalog/index.c:1633"
  - "postgres/src/backend/catalog/index.c:1637"
  - "postgres/src/backend/catalog/index.c:2936"
  - "postgres/src/backend/utils/cache/relcache.c:3827"
reproduced: false
---

# `could not find tuple for relation %u`

## What it means

Internal error. Code looked up a specific catalog tuple for a relation and did not find it. The placeholder is the relation OID. It is closely related to "cache lookup failed" — a required catalog row is missing where the code expected it.

## When it happens

A concurrent drop or ALTER of the relation, catalog inconsistency, or an operation on a relation whose catalog state changed underneath it (index, relcache rebuild). Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry — the relation changed or is gone. If it recurs for one OID, inspect the catalogs (`pg_class` and related) for that OID; a genuinely missing row is corruption. Report reproducible cases.

## Example

*Illustrative* — a relation altered concurrently.

```text
ERROR:  could not find tuple for relation 16840
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [cache lookup failed for index](./cache-lookup-failed-for-index.md)
