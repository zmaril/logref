---
message: "could not create socket waiting event: error code %lu"
slug: could-not-create-socket-waiting-event-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/port/win32/socket.c:195"
reproduced: false
---

# `could not create socket waiting event: error code %lu`

## What it means

On Windows, the server could not create the event object it uses to wait for activity on a socket. The `%lu` is the OS error code. This event object backs the wait-for-socket mechanism.

## When it happens

It happens during socket I/O on Windows when the waiting event object cannot be created, usually from OS-level handle exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle or memory exhaustion, resolve the pressure, and retry the operation.

## Example

*Illustrative* — a socket waiting event failing to create.

```text
ERROR:  could not create socket waiting event: error code 8
```

## Related

- [could not create signal listener pipe for PID: error code](./could-not-create-signal-listener-pipe-for-pid-error-code.md)
- [could not create timer event: error code](./could-not-create-timer-event-error-code.md)
