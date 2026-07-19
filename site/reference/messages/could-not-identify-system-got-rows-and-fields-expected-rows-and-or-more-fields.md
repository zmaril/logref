---
message: "could not identify system: got %d rows and %d fields, expected %d rows and %d or more fields"
slug: could-not-identify-system-got-rows-and-fields-expected-rows-and-or-more-fields
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:430"
  - "postgres/src/bin/pg_basebackup/streamutil.c:467"
reproduced: false
---

# `could not identify system: got %d rows and %d fields, expected %d rows and %d or more fields`

## What it means

A streaming client (`pg_basebackup`, `pg_receivewal`, or a physical-replication consumer) ran `IDENTIFY_SYSTEM` on the server and got back a result of an unexpected shape. The numbers are the rows and fields it received versus what it required.

## When it happens

The endpoint was not a Postgres replication connection, or its version returns a differently shaped `IDENTIFY_SYSTEM` result. It usually means the tool connected to something other than a compatible server.

## How to fix

Confirm the connection targets a real Postgres server that supports the replication protocol and that its major version is compatible with the client tool. Check the host, port, and that a pooler or proxy is not sitting in the path.

## Example

*Illustrative* — IDENTIFY_SYSTEM returned the wrong shape.

```text
pg_basebackup: error: could not identify system: got 1 rows and 3 fields, expected 1 rows and 4 or more fields
```

## Related

- [could not obtain publication information](./could-not-obtain-publication-information.md)
- [could not parse connection string](./could-not-parse-connection-string.md)
