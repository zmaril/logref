---
message: "empty COPY message"
slug: empty-copy-message
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1575"
reproduced: false
---

# `empty COPY message`

## What it means

`pg_basebackup` received an empty `COPY` data message from the server while streaming the base backup. A zero-length copy message is unexpected and breaks the backup stream.

## When it happens

It fires in `pg_basebackup` during the copy phase of a base backup, when the server sends an empty data message, usually because of a protocol or connection fault.

## How to fix

Check the server log for a crash, a killed walsender, or a network interruption during the backup. Ensure the connection is stable and the server has adequate resources, then retry the base backup.

## Example

*Illustrative* — an empty copy message during base backup.

```text
pg_basebackup: error: empty COPY message
```

## Related

- [error reading result of streaming command](./error-reading-result-of-streaming-command.md)
- [dumping the contents of table failed: PQgetCopyData() failed](./dumping-the-contents-of-table-failed-pqgetcopydata-failed.md)
