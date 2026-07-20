---
message: "connection to database \"%s\" failed"
slug: connection-to-database-failed-b0df15
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/vacuumlo/vacuumlo.c:109"
  - "postgres/src/bin/pgbench/pgbench.c:1564"
reproduced: false
---

# `connection to database "%s" failed`

## What it means

A client program could not connect to the named database. The placeholder is the database name. This comes from utilities such as `vacuumlo` and `pgbench` when the initial connection attempt fails.

## When it happens

Running a client tool with a wrong host, port, database name, or credentials; the server not accepting connections; a `pg_hba.conf` rule rejecting the client; or the network path being blocked.

## How to fix

Verify the connection parameters (host, port, dbname, user) and that the server is running and reachable. Check `pg_hba.conf` allows the client and authentication method, and confirm the credentials. The accompanying detail line usually names the specific failure to address.

## Example

*Illustrative* — a tool failing to connect.

```text
vacuumlo: connection to database "app" failed: FATAL:  password authentication failed for user "app"
```

## Related

- [could not connect to database](./could-not-connect-to-database-ec9b7c.md)
- [could not accept SSL connection: EOF detected](./could-not-accept-ssl-connection-eof-detected.md)
