---
message: "could not fetch group access flag: got %d rows and %d fields, expected %d rows and %d or more fields"
slug: could-not-fetch-group-access-flag-got-rows-and-fields-expected-rows-and-or-more
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:378"
reproduced: false
---

# `could not fetch group access flag: got %d rows and %d fields, expected %d rows and %d or more fields`

## What it means

`pg_basebackup`'s streaming utility queried the server for the data-directory group-access flag and got a reply with an unexpected number of rows or fields. This is a protocol-consistency check.

## When it happens

It happens during base-backup setup when the server's reply to the group-access query does not match what the client expects, usually from a client and server version mismatch.

## How to fix

Use client tools whose major version matches the server. An unexpected reply shape points at an unsupported version combination.

## Example

*Illustrative* — an unexpected reply shape for the group-access flag.

```text
pg_basebackup: error: could not fetch group access flag: got 0 rows and 0 fields, expected 1 rows and 1 or more fields
```

## Related

- [could not fetch WAL segment size: got rows and fields, expected rows and or more fields](./could-not-fetch-wal-segment-size-got-rows-and-fields-expected-rows-and-or-more.md)
- [could not determine server setting for integer_datetimes](./could-not-determine-server-setting-for-integer-datetimes.md)
