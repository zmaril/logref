---
message: "removing WAL directory \"%s\""
slug: removing-wal-directory
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:799"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:259"
reproduced: false
---

# `removing WAL directory "%s"`

## What it means

A tool is deleting the target WAL directory entirely, including the directory itself.

## When it happens

It is printed at INFO during cleanup or overwrite by tools that manage a separate WAL directory, such as `pg_basebackup --waldir`.

## Is this a problem?

Expected during cleanup or a fresh overwrite. Confirm the path is correct. If it follows a failure, look at the earlier error rather than the removal.

## Example

*Illustrative* — removing a separate WAL directory during cleanup.

```text
INFO:  removing WAL directory "/var/lib/pg/wal_target"
```

## Related

- [removing data directory](./removing-data-directory.md)
- [removing contents of WAL directory](./removing-contents-of-wal-directory.md)
