---
message: "cache lookup failed for range type %u"
slug: cache-lookup-failed-for-range-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:3809"
  - "postgres/src/backend/utils/cache/typcache.c:1024"
reproduced: false
---

# `cache lookup failed for range type %u`

## What it means

Internal error. A range type's catalog row (`pg_range`) could not be found by OID. The placeholder is the OID. Range-value code held a type OID it expected to still resolve to a range definition.

## When it happens

A concurrent `DROP TYPE` on a range type still in use, or catalog inconsistency. Ordinary range-value operations do not raise it.

## How to fix

If type DDL was running concurrently, retry. If it persists, check `pg_range` and `pg_type` for the OID; a missing row indicates corruption. Report the reproduction steps.

## Example

*Illustrative* — a range type dropped while a value still referenced it.

```text
ERROR:  cache lookup failed for range type 3904
```

## Related

- [cache lookup failed for operator family](./cache-lookup-failed-for-operator-family.md)
- [cannot convert infinity to jsonb](./cannot-convert-infinity-to-jsonb.md)
