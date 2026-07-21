---
message: "expected 1-D text array"
slug: expected-1-d-text-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/evtcache.c:232"
reproduced: false
---

# `expected 1-D text array`

## What it means

An internal guard in the event-trigger cache. It read a catalog value that should be a one-dimensional text array (the list of command tags an event trigger filters on) and found something else. It is a shape check on catalog data.

## When it happens

It fires while the server builds its cached event-trigger information if the stored tag-filter array is not a flat text array. In a healthy catalog this cannot happen.

## How to fix

This points at catalog corruption or a manually altered `pg_event_trigger` row rather than a user error. Confirm nobody edited the system catalogs directly. If the catalog was not tampered with, capture the details and report it; restoring the affected event trigger from a clean definition may be needed.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected 1-D text array
```

## Related

- [expected element float8 array](./expected-element-float8-array.md)
- [event trigger with OID does not exist](./event-trigger-with-oid-does-not-exist.md)
