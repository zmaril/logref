---
message: "could not read WAL at LSN %X/%08X"
slug: could-not-read-wal-at-lsn
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:110"
reproduced: false
---

# `could not read WAL at LSN %X/%08X`

## What it means

A `pg_walinspect` function was asked to read the write-ahead log at a specific LSN and could not. The server rejects the position as an invalid parameter value.

## When it happens

It fires when the LSN passed to a WAL-inspection function is out of range for the available log — before the earliest retained segment, past the current insert point, or otherwise not a readable record start.

## How to fix

Pass an LSN that falls inside the currently available WAL. Bound your query with `pg_current_wal_lsn()` for the upper end and a real record position for the lower end. Inspecting flushed WAL only, and within the retained range, avoids this.

## Example

*Illustrative* — an out-of-range LSN.

```sql
SELECT * FROM pg_get_wal_records_info('FF/FFFFFFFF', 'FF/FFFFFFFF');
-- ERROR:  could not read WAL at LSN FF/FFFFFFFF
```

## Related

- [could not read WAL at position (with detail)](./could-not-read-wal-at-c89934.md)
- [could not read WAL from timeline at](./could-not-read-wal-from-timeline-at-9a0c21.md)
