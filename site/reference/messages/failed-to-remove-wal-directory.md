---
message: "failed to remove WAL directory"
slug: failed-to-remove-wal-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:801"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:261"
reproduced: false
---

# `failed to remove WAL directory`

## What it means

A client tool could not remove the target WAL directory itself during cleanup. It fires in `initdb`/`pg_basebackup` when removing a WAL directory it created after a failure.

## When it happens

The WAL directory could not be removed — permissions, non-empty, in use, or an I/O error — while the tool cleaned up.

## How to fix

Check permissions and open handles, then remove the directory by hand if needed. Address the earlier failure that triggered the cleanup.

## Example

*Illustrative* — the WAL directory could not be removed.

```text
pg_basebackup: error: failed to remove WAL directory
```

## Related

- [failed to remove contents of WAL directory](./failed-to-remove-contents-of-wal-directory.md)
- [failed to remove data directory](./failed-to-remove-data-directory.md)
