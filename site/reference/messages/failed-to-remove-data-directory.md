---
message: "failed to remove data directory"
slug: failed-to-remove-data-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:787"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:248"
reproduced: false
---

# `failed to remove data directory`

## What it means

A client tool could not remove the target data directory itself during cleanup. It fires in `initdb`/`pg_basebackup` when removing a directory it created after a failure.

## When it happens

The directory could not be removed — permissions, it was not empty, in use, or an I/O error — while the tool cleaned up.

## How to fix

Check permissions and that nothing holds the directory open, then remove it by hand if needed. Address the earlier failure that triggered the cleanup.

## Example

*Illustrative* — the data directory could not be removed.

```text
initdb: error: failed to remove data directory
```

## Related

- [failed to remove contents of data directory](./failed-to-remove-contents-of-data-directory.md)
- [failed to remove WAL directory](./failed-to-remove-wal-directory.md)
