---
message: "could not create connection for setup"
slug: could-not-create-connection-for-setup
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7342"
reproduced: false
---

# `could not create connection for setup`

## What it means

`pgbench` could not open the database connection it uses to prepare a run before the benchmark loop starts.

## When it happens

It happens during `pgbench` setup when the preparatory connection fails — a server that is down or at its connection limit, or wrong connection options.

## How to fix

Confirm the server is up and reachable, check the connection options, and make sure it is not already at `max_connections`. Retry once connections succeed.

## Example

*Illustrative* — setup unable to connect.

```text
pgbench: fatal: could not create connection for setup
```

## Related

- [could not create connection for initialization](./could-not-create-connection-for-initialization.md)
- [could not create connection for client](./could-not-create-connection-for-client.md)
