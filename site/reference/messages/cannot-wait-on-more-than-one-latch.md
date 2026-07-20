---
message: "cannot wait on more than one latch"
slug: cannot-wait-on-more-than-one-latch
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:589"
reproduced: false
---

# `cannot wait on more than one latch`

## What it means

An internal guard fired in the event-loop code: a wait set was built with more than one latch event. A wait set supports a single latch, so adding a second one is not allowed.

## When it happens

It is reached from `WaitEventSet` setup used by the server and some extensions. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the code that built the wait set.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot wait on more than one latch
```

## Related

- [cannot wait on latch without a specified latch](./cannot-wait-on-latch-without-a-specified-latch.md)
- [cannot wait on socket event without a socket](./cannot-wait-on-socket-event-without-a-socket.md)
