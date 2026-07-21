---
message: "%s: could not find %s"
slug: could-not-find
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:106"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:108"
reproduced: false
---

# `%s: could not find %s`

## What it means

The `pg_combinebackup` tool could not find a required item while combining incremental backups. The placeholders are the program name and the missing item. A file, block, or metadata entry the combine step expected was absent.

## When it happens

Running `pg_combinebackup` over a chain of full and incremental backups that is incomplete — a missing backup in the chain, a deleted file, or an item the manifest references but that is not present.

## How to fix

Verify the full and incremental backup set is complete and given in the correct order, and that no files were removed. Supply every backup in the chain the incremental backups depend on. Re-run the combine with the intact, correctly ordered inputs.

## Example

*Illustrative* — a missing item during backup combination.

```text
pg_combinebackup: error: could not find backup_label
```

## Related

- [could not find header for file in tar archive](./could-not-find-header-for-file-in-tar-archive.md)
- [could not find entry for ID](./could-not-find-entry-for-id.md)
