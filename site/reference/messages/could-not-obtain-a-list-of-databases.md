---
message: "could not obtain a list of databases: %s"
slug: could-not-obtain-a-list-of-databases
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2215"
reproduced: false
---

# `could not obtain a list of databases: %s`

## What it means

`pg_createsubscriber` queried the source server for its list of databases and the query failed. The `%s` value gives the reason. It needs the database list to set up the subscriber.

## When it happens

It happens while `pg_createsubscriber` prepares the conversion, when listing databases fails — usually a connection problem, missing privileges, or a server that closed the connection.

## How to fix

Confirm the connection string reaches the source server and that the role can list databases. The included reason usually names the cause; fix the connection or permission and rerun.

## Example

*Illustrative* — the database list query failed.

```text
pg_createsubscriber: error: could not obtain a list of databases: connection to server failed
```

## Related

- [could not obtain database OID](./could-not-obtain-database-oid.md)
- [could not obtain publisher settings](./could-not-obtain-publisher-settings.md)
