---
message: "error returned by PQputCopyEnd: %s"
slug: error-returned-by-pqputcopyend
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:460"
reproduced: false
---

# `error returned by PQputCopyEnd: %s`

## What it means

`pg_restore` got an error from the client library's `PQputCopyEnd` while finishing a table-data copy to the server. The placeholder is the error. The server rejected or failed the copy at its end.

## When it happens

It fires while restoring table data, when ending the copy fails — often because the server reported a data error (such as a constraint or type violation) accumulated during the copy.

## How to fix

Read the server-side error in the log; it usually names the real problem (a bad row, a violated constraint, or a full disk). Fix the data or target schema and rerun the restore.

## Example

*Illustrative* — a copy-end failure during restore.

```text
pg_restore: error: error returned by PQputCopyEnd: ...
```

## Related

- [error returned by PQputCopyData](./error-returned-by-pqputcopydata.md)
- [Dumping the contents of table failed: PQgetResult() failed](./dumping-the-contents-of-table-failed-pqgetresult-failed.md)
