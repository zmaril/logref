---
message: "pg_ctl command is: %s"
slug: pg-ctl-command-is
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1715"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1731"
reproduced: false
---

# `pg_ctl command is: %s`

## What it means

A debug trace line that echoes the exact command `pg_ctl` will run, for visibility into how it invokes the server.

## When it happens

It appears when running `pg_ctl` with debug output, printing the constructed command line before it is executed.

## Is this a problem?

No action is needed. It is `pg_ctl` diagnostics. It is useful for confirming the arguments `pg_ctl` passes to the server.

## Example

*Illustrative* — the pg_ctl command echo.

```text
DEBUG:  pg_ctl command is: "postgres" -D "/data"
```

## Related

- [could not start server: %m](./could-not-start-server.md)
- [executing %s](./executing-ddcf88.md)
