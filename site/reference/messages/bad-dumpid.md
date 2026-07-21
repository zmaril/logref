---
message: "bad dumpId"
slug: bad-dumpid
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2006"
reproduced: false
---

# `bad dumpId`

## What it means

`pg_dump` or `pg_restore` read an archive entry whose dump identifier is out of the valid range. Dump IDs number the objects in an archive, and one fell outside the expected bounds, indicating a damaged or unreadable archive.

## When it happens

It occurs when restoring or reading a custom-format or directory-format archive that is truncated, corrupted, or not a valid dump file.

## How to fix

Verify the archive is intact and was produced by a compatible `pg_dump`. Re-transfer it if it may have been corrupted in transit, and regenerate the dump if the source file is damaged. This is a sign the archive itself cannot be trusted.

## Example

*Illustrative* — a corrupt archive entry.

```text
FATAL:  bad dumpId
```

## Related

- [bad table dumpid for table data item](./bad-table-dumpid-for-table-data-item.md)
- [badly formatted node string](./badly-formatted-node-string.md)
