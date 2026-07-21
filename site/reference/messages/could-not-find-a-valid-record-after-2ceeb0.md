---
message: "could not find a valid record after %X/%08X: %s"
slug: could-not-find-a-valid-record-after-2ceeb0
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:135"
  - "postgres/src/backend/postmaster/walsummarizer.c:1001"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1424"
reproduced: false
---

# `could not find a valid record after %X/%08X: %s`

## What it means

A WAL-reading tool (here `pg_walinspect`) started scanning forward from a given LSN and could not find a valid WAL record after it. The placeholders are the starting LSN and an error detail. Either the LSN does not begin a record, the WAL beyond it is unavailable, or the segment is damaged.

## When it happens

Passing a start LSN that is not at a record boundary, pointing past the end of available WAL, or reading WAL that has been recycled/removed or is corrupt.

## How to fix

Start from a valid record boundary — use an LSN reported by the WAL functions (for example a value from `pg_get_wal_records_info` or a known record start) rather than an arbitrary offset. Ensure the WAL segments covering the range still exist and are readable. Read the appended detail for the specific cause.

## Example

*Illustrative* — scanning from a non-record LSN.

```text
ERROR:  could not find a valid record after 0/01000000: invalid record length
```

## Related

- [could not find a valid record after](./could-not-find-a-valid-record-after-dd2f88.md)
- [could not find WAL file](./could-not-find-wal-file.md)
