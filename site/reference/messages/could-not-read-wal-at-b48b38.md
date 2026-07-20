---
message: "could not read WAL at %X/%08X"
slug: could-not-read-wal-at-b48b38
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:184"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:502"
reproduced: false
---

# `could not read WAL at %X/%08X`

## What it means

The `pg_walinspect` extension could not read WAL at the requested LSN. The `%X/%08X` is the position asked for. The function could not decode a record starting there.

## When it happens

The LSN passed to a `pg_walinspect` function was past the end of available WAL, inside a page boundary rather than at a record start, or in a segment that has been recycled or removed.

## How to fix

Pass an LSN that names a real record within currently available WAL. Use `pg_current_wal_lsn()` and the extension's own start/end helpers to choose a valid range.

## Example

*Illustrative* — an out-of-range LSN passed to pg_walinspect.

```text
ERROR:  could not read WAL at 0/FFFFFFFF
```

## Related

- [could not read WAL from timeline at](./could-not-read-wal-from-timeline-at-e58973.md)
- [could not read WAL record at](./could-not-read-wal-record-at-9b93fd.md)
