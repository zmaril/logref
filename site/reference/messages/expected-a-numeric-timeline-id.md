---
message: "Expected a numeric timeline ID."
slug: expected-a-numeric-timeline-id
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_rewind/timeline.c:75"
reproduced: false
---

# `Expected a numeric timeline ID.`

## What it means

A detail line from `pg_rewind`. While parsing a timeline-history file, it expected a numeric timeline identifier and found something that was not a number. It signals a malformed or unexpected history file.

## When it happens

It fires from `pg_rewind` when reading the target or source cluster's timeline history if a line does not begin with a numeric timeline ID — for example a corrupted, truncated, or hand-edited history file.

## How to fix

Inspect the timeline-history files (`pg_wal/*.history`) on the affected cluster for corruption or manual edits. Confirm the source and target clusters share a common history and that WAL and history files were not damaged. Regenerate from a known-good backup if a history file is corrupt, then re-run `pg_rewind`.

## Example

*Illustrative* — the accompanying detail line.

```
Expected a numeric timeline ID.
```

## Related

- [Expected a write-ahead log switchpoint location.](./expected-a-write-ahead-log-switchpoint-location.md)
- [expected start timeline but found timeline](./expected-start-timeline-but-found-timeline.md)
