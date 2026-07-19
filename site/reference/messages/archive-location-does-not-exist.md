---
message: "archive location \"%s\" does not exist"
slug: archive-location-does-not-exist
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:69"
reproduced: false
---

# `archive location "%s" does not exist`

## What it means

A tool was told to use an archive location (a directory or path) that does not exist, so it cannot read from or write to it.

## When it happens

It occurs when a backup/restore tool is given an archive directory that is missing or mistyped, or when a configured archive path points somewhere that was never created.

## How to fix

Create the archive directory or correct the path so it points at an existing location. Check for typos and that the server or tool user can access it, then retry.

## Example

*Illustrative* — an archive path that is not there.

```text
ERROR:  archive location "/backups/wal" does not exist
```

## Related

- [archive file already exists](./archive-file-already-exists.md)
- [absolute path not allowed](./absolute-path-not-allowed.md)
