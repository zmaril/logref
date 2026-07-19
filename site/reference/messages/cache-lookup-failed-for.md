---
message: "cache lookup failed for %s %u"
slug: cache-lookup-failed-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2171"
  - "postgres/src/backend/catalog/aclchk.c:3131"
  - "postgres/src/backend/catalog/aclchk.c:4177"
  - "postgres/src/backend/catalog/aclchk.c:4563"
  - "postgres/src/backend/catalog/aclchk.c:5002"
  - "postgres/src/backend/catalog/dependency.c:1272"
reproduced: false
---

# `cache lookup failed for %s %u`

## What it means

Internal error. A generic form of the cache-lookup failure: dependency and ACL code that handles many object kinds could not find a catalog row, and reports the object class name and OID. The first placeholder is the object kind, the second the OID.

## When it happens

A concurrent drop of an object still referenced during dependency tracking or ACL processing, or catalog inconsistency. Because this path handles objects generically, it can name many kinds. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry — the object was dropped. If it recurs, use the named object kind and OID to inspect the relevant catalog; a genuinely missing row is corruption warranting a restore. Report reproducible cases with the object kind and the operation.

## Example

*Illustrative* — a generic dependency lookup failing.

```text
ERROR:  cache lookup failed for relation 16384
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [cache lookup failed for type](./cache-lookup-failed-for-type.md)
