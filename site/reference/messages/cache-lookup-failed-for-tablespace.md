---
message: "cache lookup failed for tablespace %u"
slug: cache-lookup-failed-for-tablespace
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3801"
  - "postgres/src/backend/catalog/objectaddress.c:5902"
reproduced: false
---

# `cache lookup failed for tablespace %u`

## What it means

Internal error. A tablespace's catalog row (`pg_tablespace`) could not be found by OID. The placeholder is the OID. Storage or DDL code held a tablespace OID the cache could not resolve.

## When it happens

A concurrent `DROP TABLESPACE` while an object still references it, or catalog inconsistency. Ordinary access to objects in a tablespace does not raise it.

## How to fix

If tablespace DDL was running concurrently, retry. If it persists, check `pg_tablespace` for the OID; a missing row indicates corruption. Report a reproducible sequence.

## Example

*Illustrative* — a tablespace dropped mid-operation.

```text
ERROR:  cache lookup failed for tablespace 16385
```

## Related

- [cache lookup failed for schema](./cache-lookup-failed-for-schema.md)
- [cache lookup failed for event trigger](./cache-lookup-failed-for-event-trigger.md)
