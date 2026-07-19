---
message: "could not open existing write-ahead log file \"%s\": %s"
slug: could-not-open-existing-write-ahead-log-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:133"
reproduced: false
---

# `could not open existing write-ahead log file "%s": %s`

## What it means

While streaming WAL, `pg_basebackup` (or `pg_receivewal`) tried to open a WAL segment already present in the destination and the operating system refused. The `%s` value gives the cause. It opens existing segments to resume writing them.

## When it happens

It happens during a base backup or WAL receive when an existing segment in the destination cannot be opened — usually a permissions problem, or an I/O error on the destination directory.

## How to fix

Check the destination directory's permissions and storage health, and remove any damaged partial segment from an interrupted run, then rerun.

## Example

*Illustrative* — an existing segment could not be opened.

```text
pg_basebackup: error: could not open existing write-ahead log file "000000010000000000000007": Permission denied
```

## Related

- [could not open write-ahead log file](./could-not-open-write-ahead-log-file.md)
- [could not open compressed file](./could-not-open-compressed-file.md)
