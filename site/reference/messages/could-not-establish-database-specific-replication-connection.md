---
message: "could not establish database-specific replication connection"
slug: could-not-establish-database-specific-replication-connection
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:979"
reproduced: false
---

# `could not establish database-specific replication connection`

## What it means

`pg_recvlogical` could not open the database-specific replication connection it needs. Logical decoding requires a connection tied to one database, and that connection could not be established.

## When it happens

It happens at `pg_recvlogical` startup when the replication connection fails — for example no `dbname` was supplied, the server is unreachable, or `pg_hba.conf` does not permit a replication connection.

## How to fix

Supply a database name in the connection options (logical replication needs one), confirm the server is reachable, and make sure `pg_hba.conf` allows a replication connection for the role from this host.

## Example

*Illustrative* — `pg_recvlogical` unable to open a logical replication connection.

```text
pg_recvlogical: fatal: could not establish database-specific replication connection
```

## Related

- [could not connect to server](./could-not-connect-to-server-36a5ed.md)
- [could not fetch failover logical slots info from the primary server](./could-not-fetch-failover-logical-slots-info-from-the-primary-server.md)
