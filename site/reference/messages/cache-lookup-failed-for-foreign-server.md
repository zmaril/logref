---
message: "cache lookup failed for foreign server %u"
slug: cache-lookup-failed-for-foreign-server
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/foreign/foreign.c:139"
  - "postgres/src/backend/foreign/foreign.c:420"
reproduced: false
---

# `cache lookup failed for foreign server %u`

## What it means

Internal error. A foreign server's catalog row (`pg_foreign_server`) could not be found by OID. The placeholder is the OID. Foreign-table access or DDL still held a reference to a server the cache could not resolve.

## When it happens

A concurrent `DROP SERVER` removing the row while a foreign table or user mapping still points at it, or catalog inconsistency. Normal foreign-table queries do not raise it.

## How to fix

If server DDL was running concurrently, retry. If it persists, check `pg_foreign_server` for the OID; an absent row where one is expected points to corruption. Capture and report the steps.

## Example

*Illustrative* — a foreign server dropped mid-operation.

```text
ERROR:  cache lookup failed for foreign server 16610
```

## Related

- [cache lookup failed for foreign-data wrapper](./cache-lookup-failed-for-foreign-data-wrapper.md)
- [cannot copy from foreign table](./cannot-copy-from-foreign-table.md)
