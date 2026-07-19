---
message: "could not open log file \"%s\": %m"
slug: could-not-open-log-file-bcff37
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:1264"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2509"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:352"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:339"
  - "postgres/src/bin/psql/startup.c:352"
reproduced: false
---

# `could not open log file "%s": %m`

## What it means

The logging subsystem (or a client tool) could not open its log file for writing. The placeholder is the path and `%m` the OS error. When the server's logging collector cannot open its file it cannot record log output there.

## When it happens

The `log_directory`/`log_filename` target does not exist or is not writable by the server user, the filesystem is full or read-only, or a client tool's log destination is inaccessible.

## How to fix

Read the `%m` text. Ensure the log directory exists and is owned/writable by the `postgres` user, and that the filesystem has space and is mounted read-write. For relative `log_directory`, it is resolved under the data directory — confirm that path. Fix permissions or free space, then reload.

## Example

*Illustrative* — an unwritable log directory.

```text
FATAL:  could not open log file "pg_log/postgresql.log": Permission denied
```

## Related

- [could not open file for writing](./could-not-open-file-for-writing.md)
- [could not write init file](./could-not-write-init-file.md)
