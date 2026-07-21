---
message: "could not connect to server \"%s\""
slug: could-not-connect-to-server-406a41
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION
    code: "08001"
call_sites:
  - "postgres/contrib/postgres_fdw/connection.c:659"
reproduced: false
---

# `could not connect to server "%s"`

## What it means

A `postgres_fdw` foreign server connection failed. The remote PostgreSQL server named in the foreign-server definition could not be reached.

## When it happens

It happens the first time a query touches a `postgres_fdw` foreign table in a session, when opening the connection to the remote server fails.

## How to fix

Check the foreign server's `host`, `port`, and `dbname` options and the user mapping's credentials. Confirm the remote server is up and its `pg_hba.conf` permits the connecting role. A follow-on detail line usually gives the underlying libpq error.

## Example

*Illustrative* — a foreign-table query failing to reach the remote server.

```sql
SELECT * FROM remote_table;
-- ERROR:  could not connect to server "remote_srv"
```

## Related

- [could not connect to server](./could-not-connect-to-server-36a5ed.md)
- [could not connect to database](./could-not-connect-to-database-495416.md)
