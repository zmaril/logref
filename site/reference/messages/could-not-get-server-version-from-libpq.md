---
message: "could not get \"server_version\" from libpq"
slug: could-not-get-server-version-from-libpq
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:41"
reproduced: false
---

# `could not get "server_version" from libpq`

## What it means

`pg_dump` asked the client library (libpq) for the connected server's version and got nothing. It reads the version through libpq to decide which features and catalog queries apply.

## When it happens

It happens right after connecting, when libpq reports no server version for the connection — usually a connection that is not fully established, or a non-PostgreSQL endpoint answering on the port.

## How to fix

Make sure the host and port reach a real PostgreSQL server and that the connection completes. Checking the server log and confirming you are not connecting through a proxy that alters the handshake usually resolves it.

## Example

*Illustrative* — libpq reported no server version.

```text
pg_dump: error: could not get "server_version" from libpq
```

## Related

- [could not get server version](./could-not-get-server-version.md)
- [could not initiate base backup](./could-not-initiate-base-backup.md)
