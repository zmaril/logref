---
message: "cache lookup failed for extended statistics object %u"
slug: cache-lookup-failed-for-extended-statistics-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/statscmds.c:745"
reproduced: false
---

# `cache lookup failed for extended statistics object %u`

## What it means

An internal lookup for an extended-statistics object by OID found no matching row. The placeholder is the OID. The statistics object referenced during planning or a catalog operation is missing.

## When it happens

It usually reflects a race with a concurrent `DROP STATISTICS`, or catalog inconsistency involving `pg_statistic_ext`.

## How to fix

If concurrent DDL dropped the statistics object, retry the operation. If it persists with nothing dropping it, investigate catalog consistency and consider a restore from backup.

## Example

*Illustrative* — a missing statistics object.

```text
ERROR:  cache lookup failed for extended statistics object 16401
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cache lookup failed for object](./cache-lookup-failed-for-object.md)
