---
message: "could not create signal handler thread"
slug: could-not-create-signal-handler-thread
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32/signal.c:105"
reproduced: false
---

# `could not create signal handler thread`

## What it means

On Windows, the server could not start the thread that receives and dispatches its emulated signals. Without it the process cannot handle signals, so startup fails.

## When it happens

It happens at process startup on Windows when the signal-handler thread cannot be created, usually from resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for resource exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — the signal handler thread failing to start.

```text
FATAL:  could not create signal handler thread
```

## Related

- [could not create signal event: error code](./could-not-create-signal-event-error-code.md)
- [could not create I/O completion port for child queue](./could-not-create-i-o-completion-port-for-child-queue.md)
