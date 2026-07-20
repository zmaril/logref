---
message: "cannot use custom wait event string longer than %u characters"
slug: cannot-use-custom-wait-event-string-longer-than-characters
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/activity/wait_event.c:162"
reproduced: false
---

# `cannot use custom wait event string longer than %u characters`

## What it means

An extension tried to register a custom wait event whose name exceeds the fixed length limit. Wait-event names are stored in a bounded shared-memory area, so a name longer than the limit cannot be accepted.

## When it happens

It is reached from `WaitEventExtensionNew()` or the related registration call when an extension supplies an over-long wait-event name.

## How to fix

Shorten the wait-event name in the extension to fit within the reported limit. This is an extension coding matter; report it to the extension's author if you did not write it.

## Example

*Illustrative* — an over-long wait-event name.

```text
ERROR:  cannot use custom wait event string longer than 12 characters
```

## Related

- [cannot use](./cannot-use.md)
- [cannot use replication slot for logical decoding](./cannot-use-replication-slot-for-logical-decoding.md)
