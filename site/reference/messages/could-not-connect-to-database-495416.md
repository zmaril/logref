---
message: "could not connect to database %s"
slug: could-not-connect-to-database-495416
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:332"
reproduced: false
---

# `could not connect to database %s`

## What it means

The `oid2name` utility could not open a connection to the named database. The connection attempt was refused or failed before any work could start.

## When it happens

It happens when `oid2name` is run against a database that does not exist, is not accepting connections, or is unreachable with the supplied connection options.

## How to fix

Check the database name and the connection options (host, port, user). Confirm the server is running and the target database exists and accepts connections from this client.

## Example

*Illustrative* — `oid2name` failing to connect.

```text
oid2name: could not connect to database mydb
```

## Related

- [could not connect to database: out of memory](./could-not-connect-to-database-out-of-memory.md)
- [could not connect to server](./could-not-connect-to-server-36a5ed.md)
