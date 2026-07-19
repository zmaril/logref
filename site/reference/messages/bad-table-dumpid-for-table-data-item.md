---
message: "bad table dumpId for TABLE DATA item"
slug: bad-table-dumpid-for-table-data-item
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2027"
reproduced: false
---

# `bad table dumpId for TABLE DATA item`

## What it means

While reading an archive, `pg_restore` found a table-data entry that points at a dump identifier which is not a table. Table-data items must reference their owning table, and this reference was wrong.

## When it happens

It occurs when restoring a custom or directory-format archive that is corrupted or internally inconsistent.

## How to fix

Confirm the archive is intact and produced by a compatible `pg_dump`. Re-copy it if it may have been damaged in transfer, and regenerate the dump from the source database if the archive itself is broken.

## Example

*Illustrative* — a table-data item with a bad reference.

```text
FATAL:  bad table dumpId for TABLE DATA item
```

## Related

- [bad dumpid](./bad-dumpid.md)
- [badly formatted node string](./badly-formatted-node-string.md)
