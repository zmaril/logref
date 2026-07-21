---
message: "could not obtain database OID: got %d rows, expected %d row"
slug: could-not-obtain-database-oid-got-rows-expected-row
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:804"
reproduced: false
---

# `could not obtain database OID: got %d rows, expected %d row`

## What it means

`pg_createsubscriber` queried for a database's OID and the result did not have the single row it expected. The `%d` values give the row counts. An unexpected shape means the query did not return what the tool relies on.

## When it happens

It happens during subscriber setup when the OID query returns zero or multiple rows instead of one — usually the database name does not match exactly, or the catalog state is unexpected.

## How to fix

Confirm the database name is correct and unique on the server, then rerun. A zero-row result usually means the database is not present under that name.

## Example

*Illustrative* — an unexpected row count for the OID query.

```text
pg_createsubscriber: error: could not obtain database OID: got 0 rows, expected 1 row
```

## Related

- [could not obtain database OID](./could-not-obtain-database-oid.md)
- [could not obtain subscription OID: got rows, expected row](./could-not-obtain-subscription-oid-got-rows-expected-row.md)
