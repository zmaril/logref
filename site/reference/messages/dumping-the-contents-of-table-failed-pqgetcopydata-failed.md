---
message: "Dumping the contents of table \"%s\" failed: PQgetCopyData() failed."
slug: dumping-the-contents-of-table-failed-pqgetcopydata-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:2469"
reproduced: false
---

# `Dumping the contents of table "%s" failed: PQgetCopyData() failed.`

## What it means

`pg_dump` was streaming a table's rows with `COPY` and the client library's `PQgetCopyData` call failed mid-stream. The placeholder is the table name. The connection to the server broke or the server reported an error during the copy.

## When it happens

It fires while `pg_dump` reads a table's data, when the copy stream is interrupted — for example a dropped connection, a server crash, or a query cancellation.

## How to fix

Check the server log for the underlying cause (a crash, a killed backend, or a resource limit). Ensure the connection is stable and the server stayed up, then rerun the dump. A `statement_timeout` on the dumping role can also cut a long copy short.

## Example

*Illustrative* — a copy stream broke during dump.

```text
pg_dump: error: Dumping the contents of table "big" failed: PQgetCopyData() failed.
```

## Related

- [Dumping the contents of table failed: PQgetResult() failed](./dumping-the-contents-of-table-failed-pqgetresult-failed.md)
- [error returned by PQputCopyData](./error-returned-by-pqputcopydata.md)
