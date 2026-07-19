---
message: "failed to remove contents of data directory"
slug: failed-to-remove-contents-of-data-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:794"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:254"
reproduced: false
---

# `failed to remove contents of data directory`

## What it means

A client tool could not empty the target data directory during setup. It fires in `initdb` or `pg_basebackup` when clearing a directory the tool was told it may use.

## When it happens

Files in the directory could not be removed — permissions, files in use, or an I/O error — while the tool prepared a fresh data directory.

## How to fix

Check ownership and permissions on the directory and its contents, and ensure no process holds files open there. Clear or recreate the directory, then rerun.

## Example

*Illustrative* — the data directory could not be emptied.

```text
initdb: error: failed to remove contents of data directory
```

## Related

- [failed to remove data directory](./failed-to-remove-data-directory.md)
- [failed to remove contents of WAL directory](./failed-to-remove-contents-of-wal-directory.md)
