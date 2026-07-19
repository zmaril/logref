---
message: "cache lookup failed for procedure with OID %u"
slug: cache-lookup-failed-for-procedure-with-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/regproc.c:417"
reproduced: false
---

# `cache lookup failed for procedure with OID %u`

## What it means

An internal lookup for a function or procedure by OID found no `pg_proc` row. The placeholder is the OID. The routine referenced during planning or execution is missing.

## When it happens

It usually reflects a race with a concurrent `DROP FUNCTION`/`DROP PROCEDURE`, or catalog inconsistency in `pg_proc`.

## How to fix

Retry if the routine was dropped concurrently. If it persists, investigate `pg_proc` consistency and any extension that provides the routine.

## Example

*Illustrative* — a missing routine.

```text
ERROR:  cache lookup failed for procedure with OID 16440
```

## Related

- [cache lookup failed for operator with oid](./cache-lookup-failed-for-operator-with-oid.md)
- [cache lookup failed for pg_aggregate tuple for function](./cache-lookup-failed-for-pg-aggregate-tuple-for-function.md)
