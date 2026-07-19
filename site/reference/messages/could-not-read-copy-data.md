---
message: "could not read COPY data: %s"
slug: could-not-read-copy-data
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1041"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:455"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:631"
  - "postgres/src/bin/pg_basebackup/receivelog.c:987"
reproduced: false
---

# `could not read COPY data: %s`

## What it means

A tool streaming data over the COPY protocol (here `pg_basebackup`) failed while reading the next COPY message from the server. The placeholder is the connection error text. The COPY stream carrying the backup (or table data) was interrupted.

## When it happens

The server connection dropped, timed out, or errored mid-stream during a base backup or a COPY-based transfer — often a network interruption or the server going away.

## How to fix

Read the included error text for the specific cause. Check network stability between client and server, server health and logs, and any timeout settings. For large base backups over an unreliable link, ensure the connection can stay up for the full transfer, and retry.

## Example

*Illustrative* — a COPY stream interrupted.

```text
FATAL:  could not read COPY data: server closed the connection unexpectedly
```

## Related

- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
- [could not close pipe to external command](./could-not-close-pipe-to-external-command.md)
