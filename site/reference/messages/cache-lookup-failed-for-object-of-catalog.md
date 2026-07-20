---
message: "cache lookup failed for object %u of catalog \"%s\""
slug: cache-lookup-failed-for-object-of-catalog
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/alter.c:182"
  - "postgres/src/backend/commands/alter.c:708"
  - "postgres/src/backend/commands/alter.c:960"
reproduced: false
---

# `cache lookup failed for object %u of catalog "%s"`

## What it means

Internal error. Generic object-address code could not find an object by OID in the named system catalog. The placeholders are the object OID and the catalog name. It is the catalog-agnostic form of a missing-object check, used by code that resolves arbitrary object references.

## When it happens

A concurrent drop of the referenced object, or catalog inconsistency. It surfaces from generic paths (dependency handling, `COMMENT`/`SECURITY LABEL`, event triggers) rather than from a single object type. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL that dropped the object, retry. If it recurs for a specific OID and catalog, inspect that catalog for the missing row; a dangling reference indicates corruption. Report reproducible cases with the catalog name.

## Example

*Illustrative* — a generic object lookup that failed.

```text
ERROR:  cache lookup failed for object 16500 of catalog "pg_class"
```

## Related

- [cache lookup failed for conversion](./cache-lookup-failed-for-conversion.md)
- [could not find tuple for rule](./could-not-find-tuple-for-rule.md)
