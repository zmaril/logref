---
message: "could not find any WAL files"
slug: could-not-find-any-wal-files
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:484"
reproduced: false
---

# `could not find any WAL files`

## What it means

A base backup found no WAL files to include when it needed them. The server could not locate segments in `pg_wal` that the backup requires.

## When it happens

It happens during a base backup that includes WAL when the `pg_wal` directory is unexpectedly empty of the needed segments — for example segments removed out from under the backup.

## How to fix

Check the server's `pg_wal` directory and WAL retention. Aggressive WAL removal or a misconfigured archive can leave the backup without needed segments; make sure retention keeps WAL long enough for a backup to complete, then retry.

## Example

*Illustrative* — a base backup finding no WAL.

```text
ERROR:  could not find any WAL files
```

## Related

- [could not find any WAL file](./could-not-find-any-wal-file.md)
- [could not finalize checksum of file](./could-not-finalize-checksum-of-file.md)
