---
message: "could not create timer thread: error code %lu"
slug: could-not-create-timer-thread-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32/timer.c:107"
reproduced: false
---

# `could not create timer thread: error code %lu`

## What it means

On Windows, the server could not start the thread that services its timers. The `%lu` is the OS error code. Without it timed operations such as statement timeouts cannot fire.

## When it happens

It happens at startup on Windows when the timer thread cannot be created, usually from resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for resource exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — the timer thread failing to start.

```text
FATAL:  could not create timer thread: error code 8
```

## Related

- [could not create timer event: error code](./could-not-create-timer-event-error-code.md)
- [could not create signal handler thread](./could-not-create-signal-handler-thread.md)
