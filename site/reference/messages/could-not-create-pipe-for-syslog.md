---
message: "could not create pipe for syslog: %m"
slug: could-not-create-pipe-for-syslog
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:643"
  - "postgres/src/backend/postmaster/syslogger.c:657"
reproduced: false
---

# `could not create pipe for syslog: %m`

## What it means

The syslogger subprocess could not create the pipe it uses to receive log messages from other processes. The placeholder is the system reason. Without this pipe the logging collector cannot start.

## When it happens

Starting the logging collector when the OS refuses to create a pipe — typically because the process or system file-descriptor limit is exhausted, or a resource limit is reached.

## How to fix

Raise the open-file-descriptor limits for the Postgres user (`ulimit -n`, systemd `LimitNOFILE`), and check overall system resource usage. Address the descriptor or resource shortage in the OS detail, then restart the server.

## Example

*Illustrative* — the syslogger failing to create its pipe.

```text
FATAL:  could not create pipe for syslog: Too many open files
```

## Related

- [could not duplicate handle for](./could-not-duplicate-handle-for.md)
- [could not create missing directory](./could-not-create-missing-directory.md)
