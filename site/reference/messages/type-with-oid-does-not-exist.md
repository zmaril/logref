---
message: "type with OID %u does not exist"
slug: type-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:3804"
  - "postgres/src/backend/catalog/aclchk.c:3831"
  - "postgres/src/backend/catalog/aclchk.c:3860"
  - "postgres/src/backend/utils/cache/typcache.c:483"
  - "postgres/src/backend/utils/cache/typcache.c:538"
reproduced: false
---

# `type with OID %u does not exist`

## What it means

Code looked up a data type by OID and found no matching row in `pg_type`. The placeholder is the OID. A missing type row for an OID in active use usually means the type was dropped concurrently or the catalog is inconsistent.

## When it happens

Most often a concurrent `DROP TYPE` (or dropping an extension that owns the type) while an operation referencing it runs; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry — the type was dropped. If it recurs without concurrent drops, inspect the dependent objects and the catalog; a persistently missing type row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped type.

```text
ERROR:  type with OID 16487 does not exist
```

## Related

- [type with oid not supported](./type-with-oid-not-supported.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
