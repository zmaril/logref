---
message: "could not create connection for client %d"
slug: could-not-create-connection-for-client
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7584"
reproduced: false
---

# `could not create connection for client %d`

## What it means

`pgbench` could not open a database connection for one of its simulated clients. The `%d` is the client number. The benchmark cannot proceed with that client unconnected.

## When it happens

It happens while `pgbench` sets up its client connections at the start of a run, when one connection attempt fails — a server at its connection limit, or bad connection options.

## How to fix

Check the server's `max_connections` against the client count (`-c`) plus any headroom, confirm the connection options are correct, and make sure the server accepts connections from this host. Lower `-c` or raise `max_connections` as needed.

## Example

*Illustrative* — a benchmark client unable to connect.

```text
pgbench: fatal: could not create connection for client 12
```

## Related

- [could not create connection for setup](./could-not-create-connection-for-setup.md)
- [could not create connection for initialization](./could-not-create-connection-for-initialization.md)
