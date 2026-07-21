---
message: "could not create syslogger data transfer thread: %m"
slug: could-not-create-syslogger-data-transfer-thread
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:320"
reproduced: false
---

# `could not create syslogger data transfer thread: %m`

## What it means

On Windows, the logging collector could not start the thread it uses to move log data from backends into the log file. The `%m` reason gives the OS error. Without it the syslogger cannot run.

## When it happens

It happens when `logging_collector` is on and the syslogger's data-transfer thread cannot be created at startup, usually from resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for resource exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — the syslogger transfer thread failing to start.

```text
FATAL:  could not create syslogger data transfer thread: ...reason...
```

## Related

- [could not create signal handler thread](./could-not-create-signal-handler-thread.md)
- [could not create background thread](./could-not-create-background-thread.md)
