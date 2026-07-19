---
message: "could not find a valid record after %X/%08X"
slug: could-not-find-a-valid-record-after-dd2f88
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:139"
  - "postgres/src/backend/postmaster/walsummarizer.c:1005"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1427"
reproduced: false
---

# `could not find a valid record after %X/%08X`

## What it means

A WAL-reading operation scanned forward from an LSN and found no valid WAL record after it. The placeholder is the starting LSN. As with the detailed variant, this means the start point is not a record boundary, the WAL is unavailable past it, or the log is damaged.

## When it happens

Supplying an LSN that is not at a record start, reading beyond the end of retained WAL, or encountering recycled or corrupt WAL segments.

## How to fix

Begin from a valid record boundary drawn from the WAL inspection functions, and confirm the covering WAL segments are still present and readable. If WAL has been recycled, the range is simply no longer available. Check for storage corruption if the segments exist but do not parse.

## Example

*Illustrative* — no valid record after the given LSN.

```text
ERROR:  could not find a valid record after 0/01000000
```

## Related

- [could not find a valid record after](./could-not-find-a-valid-record-after-2ceeb0.md)
- [syntax error in history file](./syntax-error-in-history-file.md)
