---
message: "symbolic link \"%s\" target is too long"
slug: symbolic-link-target-is-too-long
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, WARNING]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9682"
  - "postgres/src/backend/backup/basebackup.c:1422"
  - "postgres/src/backend/catalog/pg_tablespace.c:83"
  - "postgres/src/bin/pg_rewind/file_ops.c:467"
reproduced: false
---

# `symbolic link "%s" target is too long`

## What it means

Postgres encountered a symbolic link — typically a per-tablespace link under `pg_tblspc` — whose target path is longer than the fixed buffer the server and its tools use to record link targets. The placeholder is the link name. Tablespace link targets must fit within a compile-time maximum so they can be stored and reproduced during backup and recovery.

## When it happens

A tablespace located at a very deep or long filesystem path, so the symlink Postgres reads for it exceeds the allowed length; it can surface in the running server, during base backup, or in recovery tooling.

## How to fix

Relocate the tablespace to a shorter path. Create the tablespace under a shallower directory (or use a symlink at a shorter parent path that the OS resolves), then move the data and update the tablespace. The limit is on the stored target string, so shortening the actual path is the remedy.

## Example

*Illustrative* — an over-long tablespace link target.

```text
WARNING:  symbolic link "pg_tblspc/16500" target is too long
```

## Related

- [could not remove symbolic link](./could-not-remove-symbolic-link.md)
- [only shared relations can be placed in pg_global tablespace](./only-shared-relations-can-be-placed-in-pg-global-tablespace.md)
