---
message: "Expected a write-ahead log switchpoint location."
slug: expected-a-write-ahead-log-switchpoint-location
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_rewind/timeline.c:81"
reproduced: false
---

# `Expected a write-ahead log switchpoint location.`

## What it means

A detail line from `pg_rewind`. While parsing a timeline-history file, it expected a write-ahead log switchpoint location (a WAL LSN marking where one timeline diverged from another) and found something that did not parse as one.

## When it happens

It fires from `pg_rewind` when a timeline-history line is missing or has a malformed switchpoint LSN, usually because the history file is corrupted, truncated, or edited by hand.

## How to fix

Examine the `pg_wal/*.history` files on the cluster for corruption or manual changes. Ensure the source and target share a valid, intact history. Restore the affected history file from a clean backup if it is damaged, then re-run `pg_rewind`.

## Example

*Illustrative* — the accompanying detail line.

```
Expected a write-ahead log switchpoint location.
```

## Related

- [Expected a numeric timeline ID.](./expected-a-numeric-timeline-id.md)
- [expected end timeline but found timeline](./expected-end-timeline-but-found-timeline.md)
