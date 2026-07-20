---
message: "could not send COPY data: %s"
slug: could-not-send-copy-data
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1855"
reproduced: false
---

# `could not send COPY data: %s`

## What it means

`pg_basebackup` could not send COPY-protocol data to the server. The trailing text is the server or connection error. During a backup the tool streams data using the COPY sub-protocol.

## When it happens

It fires while `pg_basebackup` pushes data to the server over a replication connection and the send fails — a dropped connection or a server that closed the stream.

## How to fix

Check the connection between the tool and the server, and the server's log for why it closed the stream. A network interruption or a server shutdown during the backup is the usual cause. Restore the connection and rerun the backup.

## Example

*Illustrative* — sending COPY data failed.

```text
pg_basebackup: error: could not send COPY data: server closed the connection unexpectedly
```

## Related

- [could not send end-of-COPY](./could-not-send-end-of-copy.md)
- [could not send command to background pipe](./could-not-send-command-to-background-pipe.md)
