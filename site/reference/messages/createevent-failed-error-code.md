---
message: "CreateEvent failed: error code %lu"
slug: createevent-failed-error-code
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/latch.c:73"
  - "postgres/src/backend/storage/ipc/latch.c:107"
reproduced: false
---

# `CreateEvent failed: error code %lu`

## What it means

Internal error on Windows. A `CreateEvent` call for a latch or wait-event object failed. The `%lu` is the Windows error code. Postgres uses these kernel events to implement waiting.

## When it happens

It fires on Windows when the kernel could not create an event object — typically under handle exhaustion or extreme resource pressure. It does not occur on other platforms.

## How to fix

Check the Windows host for handle or memory exhaustion and overall load. This is a low-level resource guard; if it recurs on a healthy host, capture the error code and report it.

## Example

*Illustrative* — CreateEvent failed under handle pressure.

```text
ERROR:  CreateEvent failed: error code 8
```

## Related

- [failed to enumerate network events: error code](./failed-to-enumerate-network-events-error-code.md)
- [fcntl(F_SETFD) failed on socket](./fcntl-f-setfd-failed-on-socket.md)
