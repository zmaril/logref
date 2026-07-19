---
message: "failed to remove contents of WAL directory"
slug: failed-to-remove-contents-of-wal-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:807"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:267"
reproduced: false
---

# `failed to remove contents of WAL directory`

## What it means

A client tool could not empty the target WAL directory during setup. It fires in `initdb` or `pg_basebackup` when clearing a separate WAL directory it was told it may use.

## When it happens

Files in the WAL directory could not be removed — permissions, open files, or an I/O error — while the tool prepared it.

## How to fix

Check ownership and permissions on the WAL directory and its contents, and that no process holds files there. Clear or recreate it, then rerun.

## Example

*Illustrative* — the WAL directory could not be emptied.

```text
pg_basebackup: error: failed to remove contents of WAL directory
```

## Related

- [failed to remove WAL directory](./failed-to-remove-wal-directory.md)
- [failed to remove contents of data directory](./failed-to-remove-contents-of-data-directory.md)
