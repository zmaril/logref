---
message: "could not determine server setting for \"integer_datetimes\""
slug: could-not-determine-server-setting-for-integer-datetimes
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:246"
reproduced: false
---

# `could not determine server setting for "integer_datetimes"`

## What it means

A frontend tool could not read the server's `integer_datetimes` setting, which it needs to interpret timestamp values on the wire correctly. The setting was missing from the server's reply.

## When it happens

It happens when a streaming client connects and the server does not report `integer_datetimes` as expected, usually from a client and server version mismatch or a non-standard server.

## How to fix

Use client tools whose version is compatible with the server. Modern PostgreSQL always builds with integer datetimes; a missing setting points at an unusual or very old server the tool cannot work with.

## Example

*Illustrative* — the setting missing from the server handshake.

```text
pg_basebackup: error: could not determine server setting for "integer_datetimes"
```

## Related

- [could not create replication slot: got rows and fields, expected rows and fields](./could-not-create-replication-slot-got-rows-and-fields-expected-rows-and-fields.md)
- [could not connect to server](./could-not-connect-to-server-36a5ed.md)
