---
message: "The WAL segment size must be a power of two between 1 MB and 1 GB."
slug: the-wal-segment-size-must-be-a-power-of-two-between-1-mb-and-1-gb
passthrough: false
api: [pg_log_error_detail, pg_log_warning_detail]
level: [ERROR, WARNING]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:336"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:193"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1054"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:209"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:252"
reproduced: false
---

# `The WAL segment size must be a power of two between 1 MB and 1 GB.`

## What it means

A detail message explaining that a supplied WAL segment size is invalid. The WAL segment size must be a power of two within the range 1 MB to 1 GB; a value outside that set, or not a power of two, is rejected.

## When it happens

Passing an invalid `--wal-segsize` to `initdb`, or a tool detecting a WAL segment size that is not a valid power-of-two value in the required range.

## How to fix

Choose a WAL segment size that is a power of two between 1 and 1024 MB (1, 2, 4, 8, and so on up to 1024). Supply that value to `initdb --wal-segsize` (the value is in MB). The segment size is fixed at cluster initialization and cannot be changed afterward without reinitializing.

## Example

*Illustrative* — an invalid WAL segment size.

```text
DETAIL:  The WAL segment size must be a power of two between 1 MB and 1 GB.
```

## Related

- [increase the configuration parameter to at least](./increase-the-configuration-parameter-to-at-least.md)
- [could not parse write-ahead log location](./could-not-parse-write-ahead-log-location.md)
