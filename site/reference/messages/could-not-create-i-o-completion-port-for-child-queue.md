---
message: "could not create I/O completion port for child queue"
slug: could-not-create-i-o-completion-port-for-child-queue
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1039"
reproduced: false
---

# `could not create I/O completion port for child queue`

## What it means

On Windows, the postmaster could not create the I/O completion port it uses to track child backends. Without it the server cannot manage its worker processes, so startup fails.

## When it happens

It happens at server startup on Windows when the OS refuses to create the completion port, usually from resource exhaustion at the OS level.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle or memory exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — the completion port failing to create at startup.

```text
FATAL:  could not create I/O completion port for child queue
```

## Related

- [could not create signal event: error code](./could-not-create-signal-event-error-code.md)
- [could not create signal handler thread](./could-not-create-signal-handler-thread.md)
