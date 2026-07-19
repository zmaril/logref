---
message: "did not find magic string in file header"
slug: did-not-find-magic-string-in-file-header
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:4208"
reproduced: false
---

# `did not find magic string in file header`

## What it means

`pg_restore` opened an archive file and the leading magic bytes were not the ones a PostgreSQL custom-format archive begins with. The file is not a valid dump archive, or it is damaged.

## When it happens

It fires in `pg_restore` (or `pg_dump` reading an archive) when the input is not a PostgreSQL custom/directory-format archive — for example a plain-text SQL dump, a truncated file, or an unrelated file.

## How to fix

Make sure the file is a custom-format (`-Fc`) or directory-format (`-Fd`) archive produced by `pg_dump`. A plain SQL dump is restored with `psql`, not `pg_restore`. If the archive should be valid, it may be truncated or corrupted — re-copy or regenerate it.

## Example

*Illustrative* — feeding a plain SQL file to pg_restore.

```text
pg_restore: error: did not find magic string in file header
```

## Related

- [directory does not appear to be a valid archive (toc.dat does not exist)](./directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist.md)
- [entry ID out of range -- perhaps a corrupt TOC](./entry-id-out-of-range-perhaps-a-corrupt-toc.md)
