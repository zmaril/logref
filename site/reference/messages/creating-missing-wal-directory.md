---
message: "creating missing WAL directory \"%s\""
slug: creating-missing-wal-directory
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4175"
  - "postgres/src/backend/access/transam/xlog.c:4196"
reproduced: false
---

# `creating missing WAL directory "%s"`

## What it means

A log message that the server found a required WAL-related directory absent and created it.

## When it happens

It arises at startup or during recovery when a directory under `pg_wal` (such as `archive_status`) is missing and the server recreates it.

## Is this a problem?

No action is needed. Recreating a missing WAL subdirectory is normal self-repair. If it appears every start, investigate why the directory is being removed between runs (for example an over-aggressive cleanup job).

## Example

*Illustrative* — recreating a missing WAL directory.

```text
LOG:  creating missing WAL directory "pg_wal/archive_status"
```

## Related

- [WAL directory location must be an absolute path](./wal-directory-location-must-be-an-absolute-path.md)
- [could not create archive status file "%s": %m](./could-not-create-archive-status-file-61993b.md)
