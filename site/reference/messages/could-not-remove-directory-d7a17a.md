---
message: "could not remove directory \"%s\": %m"
slug: could-not-remove-directory-d7a17a
passthrough: false
api: [ereport, pg_fatal, pg_log_warning]
level: [ERROR, FATAL, LOG, WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/commands/tablespace.c:773"
  - "postgres/src/backend/commands/tablespace.c:786"
  - "postgres/src/backend/commands/tablespace.c:821"
  - "postgres/src/backend/commands/tablespace.c:911"
  - "postgres/src/backend/storage/file/fd.c:3418"
  - "postgres/src/backend/storage/file/fd.c:3827"
  - "postgres/src/bin/pg_rewind/file_ops.c:269"
  - "postgres/src/common/rmtree.c:124"
reproduced: false
---

# `could not remove directory "%s": %m`

## What it means

Removing a directory (`rmdir()`) failed. The path is the first placeholder and `%m` the OS error. Postgres removes directories when dropping tablespaces, cleaning temp directories, or tearing down relation storage.

## When it happens

`DROP TABLESPACE`, cleanup of temporary or backup directories, or removing per-database subdirectories. Common `%m`: `Directory not empty` (leftover files remain), `Permission denied`, or `No such file or directory` (already gone).

## How to fix

Read `%m`. `Directory not empty` is the frequent case for `DROP TABLESPACE` — the tablespace still contains objects, or orphaned files remain; ensure all objects are moved/dropped first, and investigate leftover files. `Permission denied` is an ownership problem. Resolve the specific cause before retrying.

## Example

*Illustrative* — dropping a tablespace that still holds files.

```sql
DROP TABLESPACE fast;
```

Produces:

```text
ERROR:  could not remove directory "pg_tblspc/16500": Directory not empty
```

## Related

- [could not remove file](./could-not-remove-file-cd3a60.md)
- [directory exists but is not empty](./directory-exists-but-is-not-empty.md)
