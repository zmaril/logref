---
message: "could not obtain database OID: %s"
slug: could-not-obtain-database-oid
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:797"
reproduced: false
---

# `could not obtain database OID: %s`

## What it means

`pg_createsubscriber` queried a server for a database's OID and the query failed. The `%s` value gives the reason. It uses the OID to identify the database during setup.

## When it happens

It happens during subscriber setup when the OID query fails — usually a connection problem, a database that does not exist, or missing privileges.

## How to fix

Confirm the named database exists on the target and the connection role can query it, then rerun. The included reason usually points at the connection or permission cause.

## Example

*Illustrative* — the database OID query failed.

```text
pg_createsubscriber: error: could not obtain database OID: connection to server failed
```

## Related

- [could not obtain database OID: got rows, expected row](./could-not-obtain-database-oid-got-rows-expected-row.md)
- [could not obtain a list of databases](./could-not-obtain-a-list-of-databases.md)
