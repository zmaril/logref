---
message: "skipping special file \"%s\""
slug: skipping-special-file
passthrough: false
api: [ereport, pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1545"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1019"
reproduced: false
---

# `skipping special file "%s"`

## What it means

A file-copying operation encountered a directory entry that is not a regular file — a socket, device node, or named pipe — and skipped it because such files cannot meaningfully be copied.

## When it happens

It is emitted at WARNING by tools like `pg_basebackup` when a special file is present inside the data directory tree being copied.

## Is this a problem?

Special files inside a data directory are unusual and are safely omitted from the copy. Investigate why the file is there (it should not normally be in `PGDATA`), but the skip itself does not harm the backup.

## Example

*Illustrative* — a base backup skipping a socket in the data directory.

```text
WARNING:  skipping special file "./.s.PGSQL.5432"
```

## Related

- [skipping reindex of invalid index](./skipping-reindex-of-invalid-index.md)
- [skipping locale with too-long name](./skipping-locale-with-too-long-name.md)
