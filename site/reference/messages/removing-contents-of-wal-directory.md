---
message: "removing contents of WAL directory \"%s\""
slug: removing-contents-of-wal-directory
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:805"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:265"
reproduced: false
---

# `removing contents of WAL directory "%s"`

## What it means

A tool is emptying the contents of the target WAL directory while leaving the directory itself in place.

## When it happens

It is printed at INFO by tools like `pg_basebackup` (with a separate `--waldir`) or `pg_rewind` when they clear an existing WAL directory before repopulating it.

## Is this a problem?

Expected when overwriting an existing target. Confirm the WAL path is correct, since its previous contents are being deleted. No action is otherwise required.

## Example

*Illustrative* — clearing a separate WAL directory before a backup.

```text
INFO:  removing contents of WAL directory "/var/lib/pg/wal"
```

## Related

- [removing contents of data directory](./removing-contents-of-data-directory.md)
- [removing WAL directory](./removing-wal-directory.md)
