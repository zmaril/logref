---
message: "WAL start LSN must be less than current LSN"
slug: wal-start-lsn-must-be-less-than-current-lsn
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:531"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:837"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:856"
reproduced: false
---

# `WAL start LSN must be less than current LSN`

## What it means

A WAL inspection function was given a starting log position at or beyond the current end of WAL. The requested start must fall within WAL that already exists, and this position points at or past the write frontier.

## When it happens

Calling a `pg_walinspect` function with a start position computed to be at or after the current insert position — for example passing a future position, or a value produced by arithmetic that overshot the end of WAL.

## How to fix

Use a start position earlier than the current WAL position, which you can read with `pg_current_wal_lsn()`. Ensure any computed range lies within written WAL, and that the start precedes the end position you pass alongside it.

## Example

*Illustrative* — a start position past the WAL frontier.

```sql
SELECT * FROM pg_get_wal_records_info('FFFFFFFF/FFFFFFFF', 'FFFFFFFF/FFFFFFFF');
```

## Related

- [requested wal segment has already been removed](./requested-wal-segment-has-already-been-removed.md)
- [unexpected wait lsn type](./unexpected-wait-lsn-type.md)
