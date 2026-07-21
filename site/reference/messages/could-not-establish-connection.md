---
message: "could not establish connection"
slug: could-not-establish-connection
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION
    code: "08001"
call_sites:
  - "postgres/contrib/dblink/dblink.c:235"
  - "postgres/contrib/dblink/dblink.c:337"
  - "postgres/src/include/libpq/libpq-be-fe-helpers.h:161"
  - "postgres/src/include/libpq/libpq-be-fe-helpers.h:167"
reproduced: false
---

# `could not establish connection`

## What it means

The `dblink` extension could not open a connection to the remote server. The placeholder is the connection error text from libpq. Without the connection the requested remote query cannot run.

## When it happens

Calling `dblink`/`dblink_connect` with connection parameters that fail — wrong host/port, the remote server down, authentication rejected, SSL negotiation failure, or network unreachable.

## How to fix

Read the included libpq error text for the exact cause. Verify the connection string (host, port, dbname, user), that the remote server is up and reachable, that `pg_hba.conf` on the remote permits the connection, and that credentials are correct. Test the same parameters with `psql` to isolate the problem.

## Example

*Illustrative* — a dblink connection that fails.

```text
ERROR:  could not establish connection
```

## Related

- [connection failure](./connection-failure.md)
- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
