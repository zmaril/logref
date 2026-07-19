---
message: "cache lookup failed for label %u"
slug: cache-lookup-failed-for-label
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:4088"
reproduced: false
---

# `cache lookup failed for label %u`

## What it means

An internal lookup for a security label by OID found no matching catalog row. The placeholder is the OID. The label object referenced during an operation is missing.

## When it happens

It usually reflects a race with a concurrent operation that removed the label, or a catalog inconsistency in the label catalogs.

## How to fix

Retry if concurrent DDL was involved. If it recurs with no concurrent change, investigate catalog consistency and any security-label provider extension in use.

## Example

*Illustrative* — a missing label entry.

```text
ERROR:  cache lookup failed for label 16405
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cache lookup failed for property](./cache-lookup-failed-for-property.md)
