---
message: "error returned by PQputCopyData: %s"
slug: error-returned-by-pqputcopydata
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:406"
reproduced: false
---

# `error returned by PQputCopyData: %s`

## What it means

`pg_restore` (or `pg_dump` during a copy) got an error from the client library's `PQputCopyData` while sending table data to the server. The placeholder is the error. The copy stream to the server failed.

## When it happens

It fires while restoring or copying table data, when sending a chunk to the server fails — a dropped connection, a server error mid-copy, or a server crash.

## How to fix

Check the server log for the underlying error (a constraint violation, a crash, or a disk-full on the server). Confirm the connection is stable, resolve the server-side problem, and rerun the restore.

## Example

*Illustrative* — a copy-send failure during restore.

```text
pg_restore: error: error returned by PQputCopyData: ...
```

## Related

- [error returned by PQputCopyEnd](./error-returned-by-pqputcopyend.md)
- [Dumping the contents of table failed: PQgetCopyData() failed](./dumping-the-contents-of-table-failed-pqgetcopydata-failed.md)
