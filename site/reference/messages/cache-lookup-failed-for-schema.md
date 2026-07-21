---
message: "cache lookup failed for schema %u"
slug: cache-lookup-failed-for-schema
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2999"
  - "postgres/src/backend/commands/schemacmds.c:317"
reproduced: false
---

# `cache lookup failed for schema %u`

## What it means

Internal error. A schema's catalog row (`pg_namespace`) could not be found by OID. The placeholder is the OID. Name-resolution or DDL code held a schema OID the cache could not resolve.

## When it happens

A concurrent `DROP SCHEMA` removing the row while another command still references it, or catalog inconsistency. Ordinary schema-qualified queries do not raise it.

## How to fix

If schema DDL was running concurrently, retry. If it recurs, inspect `pg_namespace` for the OID; an absent row points to corruption. Capture and report the steps.

## Example

*Illustrative* — a schema dropped while its OID was still in flight.

```text
ERROR:  cache lookup failed for schema 2200
```

## Related

- [cache lookup failed for extension](./cache-lookup-failed-for-extension.md)
- [cache lookup failed for tablespace](./cache-lookup-failed-for-tablespace.md)
