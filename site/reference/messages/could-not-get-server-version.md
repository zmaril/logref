---
message: "could not get server version"
slug: could-not-get-server-version
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:201"
reproduced: false
---

# `could not get server version`

## What it means

`pg_dump` connected to a server but could not determine its version. The tool tailors its output to the server's version, so it stops when the version is unknown.

## When it happens

It happens at the start of a dump when the version query fails or returns nothing — often a connection that dropped immediately, or a server that is not actually a PostgreSQL server.

## How to fix

Confirm the connection parameters point at a running PostgreSQL server you can reach, and check the server log if the connection is being refused mid-handshake. Once a normal connection is possible, the version is read automatically.

## Example

*Illustrative* — the server version could not be read.

```text
pg_dump: error: could not get server version
```

## Related

- [could not get server version from libpq](./could-not-get-server-version-from-libpq.md)
- [could not get system identifier](./could-not-get-system-identifier.md)
