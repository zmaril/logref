---
message: "could not get COPY data stream: %s"
slug: could-not-get-copy-data-stream
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1024"
reproduced: false
---

# `could not get COPY data stream: %s`

## What it means

`pg_basebackup` started to read a file's contents from the server as a COPY data stream and the server did not open one. The `%s` value gives the server-side detail. Backup file contents are delivered through COPY.

## When it happens

It happens during a base backup when the expected COPY stream for a file fails to start — often a server-side error mid-backup, a dropped connection, or a protocol mismatch.

## How to fix

Check the server log for an error raised during the backup and the network path for interruptions, then rerun. Make sure the client and server versions are compatible, since a protocol mismatch can surface here.

## Example

*Illustrative* — the COPY stream failed to start.

```text
pg_basebackup: fatal: could not get COPY data stream: ERROR:  canceling statement due to conflict with recovery
```

## Related

- [could not get backup header](./could-not-get-backup-header.md)
- [could not initiate base backup](./could-not-initiate-base-backup.md)
