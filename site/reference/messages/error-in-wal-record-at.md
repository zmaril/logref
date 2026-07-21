---
message: "error in WAL record at %X/%08X: %s"
slug: error-in-wal-record-at
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1526"
reproduced: false
---

# `error in WAL record at %X/%08X: %s`

## What it means

`pg_waldump` failed to decode a WAL record at a given location. The placeholders are the LSN and the decoder's error message. The record could not be read as valid WAL.

## When it happens

It fires in `pg_waldump` while iterating WAL, when a record is malformed, truncated, or the dump ran past the end of valid WAL.

## How to fix

If you are dumping active WAL, the tail may be incomplete — dump up to a flushed LSN. If the WAL should be complete, the segment may be truncated or corrupt; use an intact copy (for example from the archive). The accompanying message describes the specific decode failure.

## Example

*Illustrative* — a WAL decode failure.

```text
pg_waldump: error: error in WAL record at 0/16A0F00: invalid record length
```

## Related

- [end pointer is not a valid end point; expected](./end-pointer-is-not-a-valid-end-point-expected.md)
- [end WAL location is not inside file](./end-wal-location-is-not-inside-file.md)
