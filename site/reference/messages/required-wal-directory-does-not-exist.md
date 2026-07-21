---
message: "required WAL directory \"%s\" does not exist"
slug: required-wal-directory-does-not-exist
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4157"
  - "postgres/src/backend/access/transam/xlog.c:4168"
  - "postgres/src/backend/access/transam/xlog.c:4190"
reproduced: false
---

# `required WAL directory "%s" does not exist`

## What it means

At startup the server could not find a WAL-related directory it needs to exist. The WAL layout requires certain directories under the data directory, and one of them is missing, so the server cannot proceed. It is raised at FATAL.

## When it happens

Starting the server against a data directory that is incomplete or damaged — a missing `pg_wal` or a required subdirectory, often from a partial copy, a botched restore, or accidental deletion.

## How to fix

Restore the missing directory from a consistent backup, or recreate the data directory correctly. A partially copied or truncated data directory is the usual cause, so verify the whole directory tree is intact and that a symlinked WAL location is mounted and present.

## Example

*Illustrative* — a missing WAL directory at startup.

```text
FATAL:  required WAL directory "pg_wal/archive_status" does not exist
```

## Related

- [requested wal segment has already been removed](./requested-wal-segment-has-already-been-removed.md)
- [invalid wal segment size in control file byte](./invalid-wal-segment-size-in-control-file-byte.md)
