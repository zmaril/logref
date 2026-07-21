---
message: "Dumping the contents of table \"%s\" failed: PQgetResult() failed."
slug: dumping-the-contents-of-table-failed-pqgetresult-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:2479"
reproduced: false
---

# `Dumping the contents of table "%s" failed: PQgetResult() failed.`

## What it means

`pg_dump` finished streaming a table's rows and the client library's `PQgetResult` call, which retrieves the copy's final status, failed. The placeholder is the table name. The connection or the server failed at the end of the copy.

## When it happens

It fires while `pg_dump` completes a table's data copy, when fetching the copy result fails — a dropped connection, a server crash, or a server-side error at copy end.

## How to fix

Check the server log for the root cause. Confirm the connection stayed up and the server did not crash or cancel the session, then rerun the dump. Watch for a `statement_timeout` that could abort a long copy.

## Example

*Illustrative* — fetching the copy result failed.

```text
pg_dump: error: Dumping the contents of table "big" failed: PQgetResult() failed.
```

## Related

- [Dumping the contents of table failed: PQgetCopyData() failed](./dumping-the-contents-of-table-failed-pqgetcopydata-failed.md)
- [error returned by PQputCopyEnd](./error-returned-by-pqputcopyend.md)
