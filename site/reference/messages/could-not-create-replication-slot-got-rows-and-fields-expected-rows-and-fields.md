---
message: "could not create replication slot \"%s\": got %d rows and %d fields, expected %d rows and %d fields"
slug: could-not-create-replication-slot-got-rows-and-fields-expected-rows-and-fields
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:683"
reproduced: false
---

# `could not create replication slot "%s": got %d rows and %d fields, expected %d rows and %d fields`

## What it means

`pg_basebackup`'s streaming utility created a replication slot but the server's reply had an unexpected shape — a different number of rows or fields than the protocol expects. This is a protocol-consistency check.

## When it happens

It happens during slot creation over the replication protocol when the server's response does not match what the client version expects, usually from a client and server version mismatch.

## How to fix

Use client tools whose major version matches the server, or a supported combination. A `pg_basebackup` far newer or older than the server can see an unexpected reply shape.

## Example

*Illustrative* — an unexpected reply shape during slot creation.

```text
pg_basebackup: error: could not create replication slot "s1": got 0 rows and 0 fields, expected 1 rows and 4 fields
```

## Related

- [could not create replication slot](./could-not-create-replication-slot.md)
- [could not determine server setting for integer_datetimes](./could-not-determine-server-setting-for-integer-datetimes.md)
