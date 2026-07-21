---
message: "end pointer %X/%08X is not a valid end point; expected %X/%08X"
slug: end-pointer-is-not-a-valid-end-point-expected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:108"
reproduced: false
---

# `end pointer %X/%08X is not a valid end point; expected %X/%08X`

## What it means

`pg_rewind` parsed WAL and found that the end pointer of a record did not match the expected end point. The placeholders are the found and expected LSNs. The WAL stream is inconsistent with what `pg_rewind` expected.

## When it happens

It fires in `pg_rewind` while reading the source or target WAL, when a record's computed end LSN does not equal the anticipated boundary, usually from truncated or mismatched WAL.

## How to fix

Ensure the target cluster was cleanly shut down before `pg_rewind` and that the required WAL is present and intact on both sides. Confirm the two clusters share history from the same origin. If WAL is missing, restore it (for example from the archive) before rerunning.

## Example

*Illustrative* — an unexpected WAL end pointer.

```text
pg_rewind: fatal: end pointer 0/16A0000 is not a valid end point; expected 0/16B0000
```

## Related

- [error in WAL record at](./error-in-wal-record-at.md)
- [end WAL location is not inside file](./end-wal-location-is-not-inside-file.md)
