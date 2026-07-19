---
message: "could not connect to server"
slug: could-not-connect-to-server-36a5ed
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:189"
reproduced: false
---

# `could not connect to server`

## What it means

`pg_basebackup` (via its streaming utility) could not open a connection to the server it was told to back up. The connection failed before streaming could begin.

## When it happens

It happens at the start of a base backup or WAL-stream when the server is down, the connection options are wrong, or replication connections are not permitted.

## How to fix

Check host, port, and user, confirm the server is running, and verify `pg_hba.conf` allows a replication connection from this client. A replication connection needs an entry with the `replication` database keyword.

## Example

*Illustrative* — a base backup unable to connect.

```text
pg_basebackup: fatal: could not connect to server
```

## Related

- [could not connect to server](./could-not-connect-to-server-406a41.md)
- [could not connect to database](./could-not-connect-to-database-495416.md)
