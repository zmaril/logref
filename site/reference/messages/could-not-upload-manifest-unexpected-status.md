---
message: "could not upload manifest: unexpected status %s"
slug: could-not-upload-manifest-unexpected-status
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1847"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1874"
reproduced: false
---

# `could not upload manifest: unexpected status %s`

## What it means

`pg_basebackup` uploaded the manifest for an incremental backup and the server returned an unexpected protocol status. The `%s` is the status. The tool could not proceed with the incremental request.

## When it happens

The server responded to `UPLOAD_MANIFEST` with a status the client did not expect — usually a version mismatch or a server that does not support incremental backup the way the client assumes.

## How to fix

Confirm the server version supports incremental base backups and that WAL summarization is enabled. Align the client and server versions, then retry.

## Example

*Illustrative* — an unexpected status after manifest upload.

```text
pg_basebackup: error: could not upload manifest: unexpected status PGRES_FATAL_ERROR
```

## Related

- [could not upload manifest](./could-not-upload-manifest.md)
- [could not identify system](./could-not-identify-system-got-rows-and-fields-expected-rows-and-or-more-fields.md)
