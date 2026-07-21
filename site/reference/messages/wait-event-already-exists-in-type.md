---
message: "wait event \"%s\" already exists in type \"%s\""
slug: wait-event-already-exists-in-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/utils/activity/wait_event.c:181"
  - "postgres/src/backend/utils/activity/wait_event.c:206"
reproduced: false
---

# `wait event "%s" already exists in type "%s"`

## What it means

A custom wait event was registered under a name that is already in use within the given wait-event type, so the duplicate registration was rejected.

## When it happens

It arises when an extension registers a custom wait event whose name collides with one already registered in the same type — usually two registrations of the same name, or two extensions choosing the same name.

## How to fix

This is aimed at extension authors. Register each custom wait event name once, and choose names unlikely to collide. Check whether the extension is being initialized twice.

## Example

*Illustrative* — a duplicate custom wait event.

```text
ERROR:  wait event "MyExtWait" already exists in type "Extension"
```

## Related

- [version to install must be specified](./version-to-install-must-be-specified.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
