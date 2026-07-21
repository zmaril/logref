---
message: "could not open input file: %m"
slug: could-not-open-input-file-d824fe
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2308"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:174"
reproduced: false
---

# `could not open input file: %m`

## What it means

`pg_restore` could not open its input archive. The `%m` is the operating-system error. Without the archive there is nothing to restore.

## When it happens

The archive path was wrong, the file was unreadable by the invoking user, or it was removed or on an unmounted filesystem when the restore started.

## How to fix

Check the archive path and that the file exists and is readable. Correct the filename or permissions and rerun `pg_restore`.

## Example

*Illustrative* — the restore archive path was wrong.

```text
pg_restore: error: could not open input file: No such file or directory
```

## Related

- [could not open source file](./could-not-open-source-file.md)
- [could not read file](./could-not-read-file-read-of-a9ed38.md)
