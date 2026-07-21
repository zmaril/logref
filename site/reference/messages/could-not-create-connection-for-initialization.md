---
message: "could not create connection for initialization"
slug: could-not-create-connection-for-initialization
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:5337"
reproduced: false
---

# `could not create connection for initialization`

## What it means

`pgbench` could not open the database connection it uses during the initialization step (`pgbench -i`). Without it the test tables cannot be created and loaded.

## When it happens

It happens at the start of `pgbench -i` when the initialization connection fails — a server that is down or not accepting connections, or wrong connection options.

## How to fix

Confirm the server is running and reachable and that the connection options (host, port, user, database) are correct. Retry once the server accepts connections.

## Example

*Illustrative* — initialization unable to connect.

```text
pgbench: fatal: could not create connection for initialization
```

## Related

- [could not create connection for setup](./could-not-create-connection-for-setup.md)
- [could not create connection for client](./could-not-create-connection-for-client.md)
