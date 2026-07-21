---
message: "server version: %s; %s version: %s"
slug: server-version-version
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:223"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:53"
reproduced: false
---

# `server version: %s; %s version: %s`

## What it means

A version-reporting or version-mismatch message from a client tool. The placeholders show the server version and the tool's own name and version. It is typically emitted when a utility notes the versions it is operating against.

## When it happens

It appears from tools such as `pg_dump`, `pg_restore`, or `psql` when reporting or comparing the server version to the tool version — sometimes as context for a compatibility warning or error.

## How to fix

Read the reported versions. If a mismatch is causing trouble, use a client tool whose version is at least as new as the server (the general compatibility rule), and re-run. When it is purely informational, no action is needed.

## Example

*Illustrative* — a tool reporting server and client versions.

```text
server version: 17.2; pg_dump version: 16.4
```

## Related

- [%s: %s requires %s](./requires.md)
- [unable to initialize LZ4 library: %s](./unable-to-initialize-lz4-library.md)
