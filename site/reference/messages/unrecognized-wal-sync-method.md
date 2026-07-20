---
message: "unrecognized \"wal_sync_method\": %d"
slug: unrecognized-wal-sync-method
passthrough: false
api: [elog, ereport]
level: [ERROR, PANIC]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9310"
  - "postgres/src/backend/access/transam/xlog.c:9405"
reproduced: false
---

# `unrecognized "wal_sync_method": %d`

## What it means

The `wal_sync_method` setting resolved to an internal method code that is not one of the sync methods this build supports.

## When it happens

It arises when `wal_sync_method` is set to a value not available on the current platform/build, or when the internal method selector is otherwise out of range. At the PANIC call site it aborts a WAL flush that could not choose a sync method.

## How to fix

Set `wal_sync_method` to a value your platform supports (such as `fsync`, `fdatasync`, `open_sync`, or `open_datasync`); the valid set varies by operating system. Revert to the default if unsure, and reload the configuration.

## Example

*Illustrative* — an unsupported WAL sync method.

```text
ERROR:  unrecognized "wal_sync_method": 7
```

## Related

- [unexpected WAL source %d](./unexpected-wal-source.md)
- [unexpected WAL file size "%s"](./unexpected-wal-file-size.md)
