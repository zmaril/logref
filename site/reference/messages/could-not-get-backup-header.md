---
message: "could not get backup header: %s"
slug: could-not-get-backup-header
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2035"
reproduced: false
---

# `could not get backup header: %s`

## What it means

`pg_basebackup` asked the server for the header that precedes each backup file in the stream and did not receive it. The `%s` value gives the server-side detail. Without the header the tool cannot know the next file's name and size.

## When it happens

It happens during a base backup when the replication stream ends or errors before delivering the expected per-file header — often a dropped connection, a server-side failure mid-backup, or a protocol mismatch.

## How to fix

Check the server log for the underlying cause and the network path for interruptions, then rerun the backup. Make sure client and server versions are compatible, since a mismatched backup protocol can present this way.

## Example

*Illustrative* — the backup stream ended before a file header.

```text
pg_basebackup: fatal: could not get backup header: server closed the connection unexpectedly
```

## Related

- [could not initiate base backup](./could-not-initiate-base-backup.md)
- [could not get COPY data stream](./could-not-get-copy-data-stream.md)
