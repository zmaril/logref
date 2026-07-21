---
message: "could not create timer event: error code %lu"
slug: could-not-create-timer-event-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32/timer.c:97"
reproduced: false
---

# `could not create timer event: error code %lu`

## What it means

On Windows, the server could not create the event object backing a timer it needs, for example for statement timeouts. The `%lu` is the OS error code.

## When it happens

It happens at startup on Windows when the timer event object cannot be created, usually from OS-level handle exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle or memory exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — a timer event failing to create.

```text
FATAL:  could not create timer event: error code 8
```

## Related

- [could not create timer thread: error code](./could-not-create-timer-thread-error-code.md)
- [could not create socket waiting event: error code](./could-not-create-socket-waiting-event-error-code.md)
