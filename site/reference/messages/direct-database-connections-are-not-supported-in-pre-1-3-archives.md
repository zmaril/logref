---
message: "direct database connections are not supported in pre-1.3 archives"
slug: direct-database-connections-are-not-supported-in-pre-1-3-archives
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:410"
reproduced: false
---

# `direct database connections are not supported in pre-1.3 archives`

## What it means

`pg_restore` was asked to restore directly into a database (`-d`/`--dbname`) from an archive written in a format version older than 1.3, which lacks the metadata needed for a direct-to-database restore.

## When it happens

It fires in `pg_restore` when connecting directly to a database to restore a very old custom-format archive.

## How to fix

Restore the old archive to a SQL script instead (omit `-d`, so `pg_restore` writes to standard output) and load that with `psql`. Alternatively, regenerate the dump with a current `pg_dump` if the source database is still available.

## Example

*Illustrative* — a direct restore of a pre-1.3 archive.

```text
pg_restore: error: direct database connections are not supported in pre-1.3 archives
```

## Related

- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
- [don't know how to set owner for object type](./don-t-know-how-to-set-owner-for-object-type.md)
