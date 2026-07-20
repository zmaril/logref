---
message: "could not open write-ahead log file \"%s\": %s"
slug: could-not-open-write-ahead-log-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:175"
reproduced: false
---

# `could not open write-ahead log file "%s": %s`

## What it means

While streaming WAL, `pg_basebackup` (or `pg_receivewal`) tried to open a WAL segment for writing and the operating system refused. The `%s` value gives the cause. It opens each segment to write received WAL into it.

## When it happens

It happens during a base backup or WAL receive when a segment in the destination cannot be opened for writing — usually a permissions problem, a full destination, or an I/O error.

## How to fix

Check the destination directory's permissions, free space, and storage health, then rerun the backup or receive. The included reason names the specific problem.

## Example

*Illustrative* — a WAL segment could not be opened for writing.

```text
pg_receivewal: error: could not open write-ahead log file "000000010000000000000006.partial": Permission denied
```

## Related

- [could not open existing write-ahead log file](./could-not-open-existing-write-ahead-log-file.md)
- [could not locate WAL file](./could-not-locate-wal-file.md)
