---
message: "could not read from logger pipe: %m"
slug: could-not-read-from-logger-pipe
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:544"
  - "postgres/src/backend/postmaster/syslogger.c:1189"
reproduced: false
---

# `could not read from logger pipe: %m`

## What it means

The logging collector could not read from the pipe that backends write log messages to; the errno string gives the reason.

## When it happens

It arises in the logger process when a read on its input pipe fails — a rare operating-system condition, sometimes seen transiently during shutdown.

## Is this a problem?

This is usually a transient or shutdown-time anomaly. If it recurs during normal operation, check for operating-system pipe or file-descriptor problems; the errno is the primary clue.

## Example

*Illustrative* — a failed logger-pipe read.

```text
LOG:  could not read from logger pipe: Input/output error
```

## Related

- [could not close listen socket: %m](./could-not-close-listen-socket.md)
- [munmap(%p, %zu) failed: %m](./munmap-failed-7c74ce.md)
