---
message: "could not parse write-ahead log location \"%s\""
slug: could-not-parse-write-ahead-log-location
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:492"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:634"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2246"
  - "postgres/src/bin/pg_basebackup/streamutil.c:450"
reproduced: false
---

# `could not parse write-ahead log location "%s"`

## What it means

A tool could not parse a text write-ahead-log (WAL) location it was given. The placeholder is the offending string. WAL locations (LSNs) are written as two hex numbers joined by a slash, like `16/B374D848`; anything not in that form is rejected.

## When it happens

Passing a malformed LSN to a tool such as `pg_basebackup` (for example `--write-recovery-conf` inputs or replication start positions), or a stored/derived location string that is not in the `X/Y` hex format.

## How to fix

Provide the LSN in the correct `XXXXXXXX/XXXXXXXX` hexadecimal form. Obtain valid values from `pg_current_wal_lsn()`, `pg_control_checkpoint()`, or the tool's own output rather than hand-constructing them.

## Example

*Illustrative* — a malformed WAL location.

```text
ERROR:  could not parse write-ahead log location "16-B374D848"
```

## Related

- [the WAL segment size must be a power of two between 1 MB and 1 GB](./the-wal-segment-size-must-be-a-power-of-two-between-1-mb-and-1-gb.md)
- [could not read COPY data](./could-not-read-copy-data.md)
