---
message: "cache lookup failed for foreign-data wrapper %u"
slug: cache-lookup-failed-for-foreign-data-wrapper
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/foreign/foreign.c:64"
  - "postgres/src/backend/foreign/foreign.c:428"
reproduced: false
---

# `cache lookup failed for foreign-data wrapper %u`

## What it means

Internal error. A foreign-data wrapper's catalog row (`pg_foreign_data_wrapper`) could not be found by OID. The placeholder is the OID. Foreign-server and foreign-table code expected the wrapper to still exist.

## When it happens

A concurrent `DROP FOREIGN DATA WRAPPER` while a foreign server or table built on it is still referenced, or catalog inconsistency. It is not produced by ordinary foreign-table access.

## How to fix

If wrapper DDL was running concurrently, retry. If it recurs, inspect `pg_foreign_data_wrapper` for the OID; a missing row signals corruption. Report a reproducible sequence.

## Example

*Illustrative* — a wrapper dropped while a server still referenced it.

```text
ERROR:  cache lookup failed for foreign-data wrapper 16601
```

## Related

- [cache lookup failed for foreign server](./cache-lookup-failed-for-foreign-server.md)
- [cache lookup failed for tablespace](./cache-lookup-failed-for-tablespace.md)
