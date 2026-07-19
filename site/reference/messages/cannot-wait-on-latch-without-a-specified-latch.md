---
message: "cannot wait on latch without a specified latch"
slug: cannot-wait-on-latch-without-a-specified-latch
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:596"
reproduced: false
---

# `cannot wait on latch without a specified latch`

## What it means

An internal guard fired in the event-loop code: a wait was set up to include a latch event, but no latch was supplied. The wait-set machinery requires an actual latch object for a latch event, so this state should not occur.

## When it happens

It is reached from `WaitLatch` or `WaitEventSet` setup, which the server and some extensions use to block on events. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the code that built the wait set.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot wait on latch without a specified latch
```

## Related

- [cannot wait on more than one latch](./cannot-wait-on-more-than-one-latch.md)
- [cannot wait on socket event without a socket](./cannot-wait-on-socket-event-without-a-socket.md)
