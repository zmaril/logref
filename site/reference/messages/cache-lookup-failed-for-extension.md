---
message: "cache lookup failed for extension %u"
slug: cache-lookup-failed-for-extension
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3986"
  - "postgres/src/backend/catalog/objectaddress.c:6083"
reproduced: false
---

# `cache lookup failed for extension %u`

## What it means

Internal error. An extension's catalog row (`pg_extension`) could not be found by OID. The placeholder is the OID that failed to resolve. Something still held a reference to an extension the system cache could no longer find.

## When it happens

A concurrent `DROP EXTENSION` removing the row while another session references it, or catalog inconsistency. Ordinary SQL against extension objects does not trigger it.

## How to fix

If concurrent extension DDL was running, retry. If it persists, check `pg_extension` for the OID; an absent row indicates catalog damage. Record the reproduction steps and report them.

## Example

*Illustrative* — an extension dropped mid-operation.

```text
ERROR:  cache lookup failed for extension 16548
```

## Related

- [cache lookup failed for event trigger](./cache-lookup-failed-for-event-trigger.md)
- [cache lookup failed for schema](./cache-lookup-failed-for-schema.md)
