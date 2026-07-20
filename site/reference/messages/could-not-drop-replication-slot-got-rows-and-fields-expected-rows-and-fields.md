---
message: "could not drop replication slot \"%s\": got %d rows and %d fields, expected %d rows and %d fields"
slug: could-not-drop-replication-slot-got-rows-and-fields-expected-rows-and-fields
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:727"
reproduced: false
---

# `could not drop replication slot "%s": got %d rows and %d fields, expected %d rows and %d fields`

## What it means

`pg_basebackup`'s streaming utility dropped a replication slot but the server's reply had an unexpected shape — a different number of rows or fields than the protocol expects. This is a protocol-consistency check.

## When it happens

It happens during slot drop over the replication protocol when the server's response does not match what the client version expects, usually from a client and server version mismatch.

## How to fix

Use client tools whose major version matches the server. An unexpected reply shape points at a version combination the client does not support.

## Example

*Illustrative* — an unexpected reply shape during slot drop.

```text
pg_basebackup: error: could not drop replication slot "s1": got 1 rows and 2 fields, expected 0 rows and 0 fields
```

## Related

- [could not create replication slot: got rows and fields, expected rows and fields](./could-not-create-replication-slot-got-rows-and-fields-expected-rows-and-fields.md)
- [could not drop replication slot in database](./could-not-drop-replication-slot-in-database.md)
