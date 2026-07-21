---
message: "failed to enumerate network events: error code %d"
slug: failed-to-enumerate-network-events-error-code
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/port/win32/socket.c:644"
  - "postgres/src/backend/storage/ipc/waiteventset.c:1777"
reproduced: false
---

# `failed to enumerate network events: error code %d`

## What it means

Internal error on Windows. Enumerating pending network events on a socket failed. The `%d` is the Windows error code. It is a low-level socket-wait guard used by the event loop.

## When it happens

It fires on Windows when the socket event-enumeration call returned an error, typically under resource pressure or an unusual socket state. It does not occur on other platforms.

## How to fix

Check the Windows host for socket/handle exhaustion and network-stack issues. This is a low-level guard; if it recurs on a healthy host, capture the error code and report it.

## Example

*Illustrative* — network event enumeration failed on Windows.

```text
ERROR:  failed to enumerate network events: error code 10038
```

## Related

- [CreateEvent failed: error code](./createevent-failed-error-code.md)
- [fcntl(F_SETFD) failed on socket](./fcntl-f-setfd-failed-on-socket.md)
