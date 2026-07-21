---
message: "could not create signal listener pipe for PID %d: error code %lu"
slug: could-not-create-signal-listener-pipe-for-pid-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/port/win32/signal.c:243"
reproduced: false
---

# `could not create signal listener pipe for PID %d: error code %lu`

## What it means

On Windows, the server could not create the named pipe used to send emulated signals to a specific child process. The `%d` is the child PID and `%lu` the OS error code.

## When it happens

It happens when the postmaster prepares to signal a child on Windows and the listener pipe cannot be created, usually from OS-level resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle exhaustion, resolve the pressure, and restart the server if the problem persists.

## Example

*Illustrative* — a signal listener pipe failing to create.

```text
ERROR:  could not create signal listener pipe for PID 4321: error code 8
```

## Related

- [could not create signal event: error code](./could-not-create-signal-event-error-code.md)
- [could not create socket waiting event: error code](./could-not-create-socket-waiting-event-error-code.md)
