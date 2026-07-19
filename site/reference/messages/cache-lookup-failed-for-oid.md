---
message: "cache lookup failed for OID %u"
slug: cache-lookup-failed-for-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/stat_utils.c:212"
reproduced: false
---

# `cache lookup failed for OID %u`

## What it means

An internal lookup for a catalog object by OID found no matching row. The placeholder is the OID. The object referenced by an operation is gone or the catalog is inconsistent.

## When it happens

It usually reflects a race with a concurrent `DROP`, where the object was removed after it was referenced but before it was fetched. Catalog corruption is a less common cause.

## How to fix

Retry the operation if it coincided with concurrent DDL. If the error persists with nothing removing the object, suspect catalog corruption: check hardware and storage and consider a restore from a known-good backup.

## Example

*Illustrative* — a generic OID cache miss.

```text
ERROR:  cache lookup failed for OID 16384
```

## Related

- [cache lookup failed for object](./cache-lookup-failed-for-object.md)
- [cache lookup failed for relation](./cache-lookup-failed-for-relation-63346c.md)
