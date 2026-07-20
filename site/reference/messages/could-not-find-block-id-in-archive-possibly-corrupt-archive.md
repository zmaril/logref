---
message: "could not find block ID %d in archive -- possibly corrupt archive"
slug: could-not-find-block-id-in-archive-possibly-corrupt-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:523"
reproduced: false
---

# `could not find block ID %d in archive -- possibly corrupt archive`

## What it means

`pg_restore` looked for a data block by its ID in a custom-format archive and could not find it. The `%d` is the block ID. The message notes the likely cause is a corrupt archive.

## When it happens

It happens while restoring from a custom-format dump when an expected data block is missing from the archive file.

## How to fix

Suspect a damaged archive — a truncated or corrupted dump file is the usual cause. Verify the file's integrity, re-fetch or regenerate the dump, and retry the restore.

## Example

*Illustrative* — a missing block in a custom-format archive.

```text
pg_restore: fatal: could not find block ID 42 in archive -- possibly corrupt archive
```

## Related

- [could not find block ID in archive (out-of-order restore request)](./could-not-find-block-id-in-archive-possibly-due-to-out-of-order-restore-request.md)
- [could not find file in archive](./could-not-find-file-in-archive.md)
