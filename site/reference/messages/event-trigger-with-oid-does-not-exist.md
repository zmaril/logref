---
message: "event trigger with OID %u does not exist"
slug: event-trigger-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:526"
reproduced: false
---

# `event trigger with OID %u does not exist`

## What it means

Server code looked up an event trigger by its object identifier (OID) and found no matching catalog row. The placeholder is the OID that was searched for.

## When it happens

It fires from internal paths that resolve an event trigger by OID — for example while processing a dependency or a command that references one — when the row is gone. It most often reflects a concurrent `DROP EVENT TRIGGER` racing another operation.

## How to fix

This is usually a benign concurrency artifact: an event trigger was dropped while something else referenced it. Retry the operation. If it recurs without concurrent drops, capture the surrounding statements and report it, since the OID is normally resolved from a live catalog entry.

## Example

*Illustrative* — the message as logged.

```
ERROR:  event trigger with OID 16452 does not exist
```

## Related

- [event trigger "%s" already exists](./event-trigger-already-exists.md)
- [event trigger functions cannot have declared arguments](./event-trigger-functions-cannot-have-declared-arguments.md)
