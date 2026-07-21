---
message: "invalid WAL location: \"%s\""
slug: invalid-wal-location
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1052"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1150"
reproduced: false
---

# `invalid WAL location: "%s"`

## What it means

A write-ahead log location (LSN) value could not be parsed or is out of range. The placeholder shows the rejected text. A valid LSN looks like `X/Y` in hex.

## When it happens

It arises from functions and tools that take an LSN argument — `pg_wal_lsn_diff`, recovery target settings, replication tooling — when the value is malformed or does not fit the `hex/hex` form.

## How to fix

Pass a well-formed LSN of the form `16/B374D848` (uppercase hex, slash-separated). Copy LSNs verbatim from `pg_current_wal_lsn()` or the server log rather than retyping them, and check for truncation.

## Example

*Illustrative* — a malformed LSN string.

```sql
SELECT pg_wal_lsn_diff('not-an-lsn', '0/0');  -- invalid WAL location
```

## Related

- [invalid TLI](./invalid-tli.md)
- [invalid data in history file](./invalid-data-in-history-file-df2123.md)
