---
message: "cache lookup failed for procedure %u"
slug: cache-lookup-failed-for-procedure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:5075"
  - "postgres/src/backend/commands/functioncmds.c:2396"
reproduced: false
---

# `cache lookup failed for procedure %u`

## What it means

Internal error. A routine's catalog row (`pg_proc`) could not be found by OID. The placeholder is the OID. Code that dispatches to a function or procedure held an OID the cache could not resolve to a live row.

## When it happens

A concurrent `DROP FUNCTION`/`DROP PROCEDURE` removing the row while another session still references it, or catalog inconsistency. Calling an existing routine does not raise it.

## How to fix

If routine DDL was running concurrently, retry. If it persists, check `pg_proc` for the OID; an absent row indicates corruption. Capture and report the steps.

## Example

*Illustrative* — a procedure dropped while its OID was in use.

```text
ERROR:  cache lookup failed for procedure 16789
```

## Related

- [could not find a function named](./could-not-find-a-function-named.md)
- [cannot change routine kind](./cannot-change-routine-kind.md)
