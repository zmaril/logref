---
message: "cache lookup failed for pg_aggregate tuple for function %u"
slug: cache-lookup-failed-for-pg-aggregate-tuple-for-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1348"
reproduced: false
---

# `cache lookup failed for pg_aggregate tuple for function %u`

## What it means

An internal lookup in `pg_aggregate` for the aggregate backing a function OID found no row. The placeholder is the function OID. A function marked as an aggregate is missing its `pg_aggregate` entry.

## When it happens

It usually reflects a race with a concurrent `DROP AGGREGATE`, or catalog inconsistency between `pg_proc` and `pg_aggregate`.

## How to fix

Retry if the aggregate was being dropped. If it persists, investigate consistency between `pg_proc` and `pg_aggregate` for the function, and consider a restore from backup.

## Example

*Illustrative* — a missing pg_aggregate row.

```text
ERROR:  cache lookup failed for pg_aggregate tuple for function 16430
```

## Related

- [cache lookup failed for procedure with oid](./cache-lookup-failed-for-procedure-with-oid.md)
- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
