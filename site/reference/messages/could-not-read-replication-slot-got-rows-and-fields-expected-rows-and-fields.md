---
message: "could not read replication slot \"%s\": got %d rows and %d fields, expected %d rows and %d fields"
slug: could-not-read-replication-slot-got-rows-and-fields-expected-rows-and-fields
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:520"
reproduced: false
---

# `could not read replication slot "%s": got %d rows and %d fields, expected %d rows and %d fields`

## What it means

`pg_basebackup` queried a replication slot on the server and the result had an unexpected shape — a different number of rows or columns than the tool expects. The placeholders report what came back versus what was expected.

## When it happens

It fires when `pg_basebackup` reads a named slot and the server's reply does not match the layout the tool was built for, which usually means a server and client of mismatched major versions.

## How to fix

Use a `pg_basebackup` whose major version matches the server, or newer. Client tools are supported against their own and older server versions; running an older tool against a much newer server can produce a reply it does not understand. Upgrade the client tooling to match.

## Example

*Illustrative* — the slot query returned an unexpected shape.

```text
pg_basebackup: error: could not read replication slot "backup": got 1 rows and 5 fields, expected 1 rows and 4 fields
```

## Related

- [could not receive database system identifier and timeline ID from the primary server](./could-not-receive-database-system-identifier-and-timeline-id-from-the-primary.md)
- [could not start WAL streaming](./could-not-start-wal-streaming.md)
