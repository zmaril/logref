---
message: "could not send end-of-COPY: %s"
slug: could-not-send-end-of-copy
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1865"
reproduced: false
---

# `could not send end-of-COPY: %s`

## What it means

`pg_basebackup` could not send the end-of-COPY marker to the server. The trailing text is the underlying error. The marker tells the server a COPY-protocol transfer is finished.

## When it happens

It fires as `pg_basebackup` finishes streaming a portion of the backup and cannot signal the end of the COPY stream, which means the connection dropped near the end of the transfer.

## How to fix

Check the connection and the server's log. A network drop or a server shutdown as the transfer completed is the usual cause. Restore stable connectivity and rerun the backup.

## Example

*Illustrative* — the end-of-COPY signal could not be sent.

```text
pg_basebackup: error: could not send end-of-COPY: server closed the connection unexpectedly
```

## Related

- [could not send COPY data](./could-not-send-copy-data.md)
- [could not send command to background pipe](./could-not-send-command-to-background-pipe.md)
