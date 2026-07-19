---
message: "command is: %s"
slug: command-is
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1572"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1622"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1846"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1893"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2020"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2115"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2162"
reproduced: false
---

# `command is: %s`

## What it means

A diagnostic `DEBUG`-level line from `pg_createsubscriber` echoing the command it is about to run. The placeholder is the command string. It is informational tracing emitted when debug logging is enabled, not an error.

## When it happens

Running `pg_createsubscriber` with increased verbosity/debug output. The tool prints each internal command (SQL or shell) it executes so you can follow what it is doing while converting a standby into a logical subscriber.

## Is this a problem?

Nothing to do — this is normal debug tracing. Use it to understand or troubleshoot what `pg_createsubscriber` executed. If you did not want this detail, lower the tool's verbosity. If a later step failed, this line helps identify which command preceded the failure.

## Example

*Illustrative* — pg_createsubscriber tracing a command.

```text
DEBUG:  command is: "pg_ctl" -D "/data" -o "-p 5432" start
```

## Related

- [Query was: %s](./query-was.md)
- [could not execute command](./could-not-execute-command.md)
