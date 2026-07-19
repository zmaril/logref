---
message: "could not connect to database %s: out of memory"
slug: could-not-connect-to-database-out-of-memory
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/connect_utils.c:91"
reproduced: false
---

# `could not connect to database %s: out of memory`

## What it means

A client utility could not establish a database connection because it ran out of memory while setting the connection up. The client process, not the server, could not allocate what it needed.

## When it happens

It happens when a frontend tool opens a connection on a host under memory pressure, so the libpq connection object cannot be allocated.

## How to fix

Free memory on the client host or reduce concurrent work. If the tool opens many connections at once, lower its parallelism. Check for per-process memory limits (`ulimit -v`) that may be too tight.

## Example

*Illustrative* — a connection failing for lack of client memory.

```text
fatal: could not connect to database mydb: out of memory
```

## Related

- [could not connect to database](./could-not-connect-to-database-495416.md)
- [could not create connection for setup](./could-not-create-connection-for-setup.md)
