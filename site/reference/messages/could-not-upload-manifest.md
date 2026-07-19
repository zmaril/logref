---
message: "could not upload manifest: %s"
slug: could-not-upload-manifest
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1844"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1871"
reproduced: false
---

# `could not upload manifest: %s`

## What it means

`pg_basebackup` (incremental mode) could not upload the backup manifest to the server. The `%s` is the error. The server needs the prior manifest to compute an incremental backup.

## When it happens

The connection failed or the server rejected the upload while `pg_basebackup` sent the previous manifest for an incremental backup.

## How to fix

Read the trailing error. Confirm the connection is stable, the server supports incremental backup (a recent enough version with WAL summarization enabled), and the manifest file is valid, then retry.

## Example

*Illustrative* — the manifest upload failed on the connection.

```text
pg_basebackup: error: could not upload manifest: server closed the connection unexpectedly
```

## Related

- [could not upload manifest: unexpected status](./could-not-upload-manifest-unexpected-status.md)
- [could not obtain publication information](./could-not-obtain-publication-information.md)
