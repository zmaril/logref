---
message: "end WAL location %X/%08X is not inside file \"%s\""
slug: end-wal-location-is-not-inside-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1350"
reproduced: false
---

# `end WAL location %X/%08X is not inside file "%s"`

## What it means

`pg_waldump` was given an end WAL location that does not fall within the WAL segment file it is reading. The placeholders are the LSN and the file name. The requested end point is outside the file's range.

## When it happens

It fires in `pg_waldump` when the `--end` LSN (or the implied end) lies outside the segment file being dumped.

## How to fix

Give an end location that lies within the segment(s) you are dumping, or point `pg_waldump` at the segment file that contains the LSN. Check that the file name and the LSN belong to the same timeline and range.

## Example

*Illustrative* — an end LSN outside the segment.

```text
pg_waldump: error: end WAL location 0/3000000 is not inside file "000000010000000000000001"
```

## Related

- [ENDSEG is before STARTSEG](./endseg-is-before-startseg.md)
- [error in WAL record at](./error-in-wal-record-at.md)
