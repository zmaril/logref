---
message: "cache lookup failed for event trigger %u"
slug: cache-lookup-failed-for-event-trigger
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4003"
  - "postgres/src/backend/catalog/objectaddress.c:6104"
reproduced: false
---

# `cache lookup failed for event trigger %u`

## What it means

Internal error. An event trigger's catalog row (`pg_event_trigger`) could not be found by OID. The placeholder is the OID the lookup used. Code reached this point holding an OID it expected to still resolve to a live event trigger.

## When it happens

A concurrent `DROP EVENT TRIGGER` that removes the row while another command still references its OID, or catalog inconsistency. It does not arise from ordinary queries or data.

## How to fix

If it coincides with concurrent DDL on event triggers, retry the command. If it recurs, inspect `pg_event_trigger` for the OID; a missing row where one is expected points to catalog corruption. Capture the steps and report a reproducible case.

## Example

*Illustrative* — an event trigger dropped while its OID was still in flight.

```text
ERROR:  cache lookup failed for event trigger 16412
```

## Related

- [cache lookup failed for extension](./cache-lookup-failed-for-extension.md)
- [cache lookup failed for schema](./cache-lookup-failed-for-schema.md)
