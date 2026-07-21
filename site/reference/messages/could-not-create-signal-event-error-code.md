---
message: "could not create signal event: error code %lu"
slug: could-not-create-signal-event-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32/signal.c:99"
reproduced: false
---

# `could not create signal event: error code %lu`

## What it means

On Windows, the server could not create the event object it uses to deliver a simulated signal. The `%lu` is the OS error code. Windows lacks Unix signals, so PostgreSQL emulates them with event objects.

## When it happens

It happens at startup or process creation on Windows when creating a signal event object fails, usually from OS-level handle exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle or memory exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — a signal event failing to create.

```text
FATAL:  could not create signal event: error code 8
```

## Related

- [could not create signal handler thread](./could-not-create-signal-handler-thread.md)
- [could not create signal listener pipe for PID: error code](./could-not-create-signal-listener-pipe-for-pid-error-code.md)
