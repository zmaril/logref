---
message: "could not find entry for ID %d"
slug: could-not-find-entry-for-id
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1619"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:562"
reproduced: false
---

# `could not find entry for ID %d`

## What it means

The `pg_dump`/`pg_restore` archive machinery could not find the table-of-contents entry for a given internal ID. The placeholder is the ID. A dependency or reference pointed at an archive entry that is not present.

## When it happens

Restoring from a custom-format archive that is damaged, truncated, or internally inconsistent — a corrupted dump file, or one whose dependency references do not resolve.

## How to fix

Verify the archive file is intact and complete; regenerate the dump if it may be truncated or corrupt. If the dump is sound, capture the exact `pg_restore` command and archive and report it. Restoring from a fresh, verified dump avoids the inconsistency.

## Example

*Illustrative* — a dangling archive reference during restore.

```text
pg_restore: error: could not find entry for ID 42
```

## Related

- [could not find header for file in tar archive](./could-not-find-header-for-file-in-tar-archive.md)
- [could not find](./could-not-find.md)
