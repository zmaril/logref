---
message: "could not read WAL at %X/%08X: %s"
slug: could-not-read-wal-at-c89934
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:179"
reproduced: false
---

# `could not read WAL at %X/%08X: %s`

## What it means

A `pg_walinspect` function could not read the write-ahead log at the requested position. The placeholder is the LSN and the trailing text describes what the reader found there.

## When it happens

It fires when you call a `pg_walinspect` function with a starting position that does not sit on a valid record boundary, or points past the end of what has been written, or into WAL that is no longer on disk.

## How to fix

Give the function a valid, existing LSN. Use `pg_current_wal_lsn()` or a value from `pg_get_wal_records_info()` to find real record positions rather than an arbitrary number. If the position is old, the segment may have been recycled or archived; inspect a range that is still present in `pg_wal`.

## Example

*Illustrative* — an inspection function was given a bad position.

```sql
SELECT * FROM pg_get_wal_record_info('0/0');
-- ERROR:  could not read WAL at 0/0: invalid record offset
```

## Related

- [could not read WAL at LSN](./could-not-read-wal-at-lsn.md)
- [could not read WAL record](./could-not-read-wal-record.md)
