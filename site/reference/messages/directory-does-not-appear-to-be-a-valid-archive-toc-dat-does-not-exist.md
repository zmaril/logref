---
message: "directory \"%s\" does not appear to be a valid archive (\"toc.dat\" does not exist)"
slug: directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2293"
reproduced: false
---

# `directory "%s" does not appear to be a valid archive ("toc.dat" does not exist)`

## What it means

`pg_restore` was pointed at a directory-format archive, but the directory does not contain a `toc.dat` file, which every directory-format archive must have. The placeholder is the directory path.

## When it happens

It fires in `pg_restore` when restoring from a directory (`-Fd`) that is not actually a directory-format dump, or whose `toc.dat` is missing.

## How to fix

Point `pg_restore` at the directory that `pg_dump -Fd` produced — the one containing `toc.dat`. If `toc.dat` is missing, the directory is incomplete or was not created by `pg_dump`; regenerate the dump.

## Example

*Illustrative* — a directory that is not a dump.

```text
pg_restore: error: directory "/tmp/notadump" does not appear to be a valid archive ("toc.dat" does not exist)
```

## Related

- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
- [directory name too long](./directory-name-too-long-1e631c.md)
