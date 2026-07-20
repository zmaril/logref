---
message: "could not get system identifier: got %d rows, expected %d row"
slug: could-not-get-system-identifier-got-rows-expected-row
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:660"
reproduced: false
---

# `could not get system identifier: got %d rows, expected %d row`

## What it means

`pg_createsubscriber` queried a cluster for its system identifier and the result did not have the single row it expected. The `%d` values give the row counts. An unexpected shape means the query did not return what the tool relies on.

## When it happens

It happens during subscriber setup when the identifier query returns zero or multiple rows instead of exactly one — usually a version mismatch or a connection answering as something other than the expected server.

## How to fix

Make sure `pg_createsubscriber` is pointed at real, compatible PostgreSQL clusters and that its binary version matches them. Confirm nothing is intercepting the connection. Fix the target and rerun.

## Example

*Illustrative* — an unexpected row count from the identifier query.

```text
pg_createsubscriber: error: could not get system identifier: got 0 rows, expected 1 row
```

## Related

- [could not get system identifier](./could-not-get-system-identifier.md)
- [could not get server version](./could-not-get-server-version.md)
