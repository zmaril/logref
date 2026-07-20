---
message: "could not read file \"%s\": read %d of %d"
slug: could-not-read-file-read-of-4dc01a
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:262"
reproduced: false
---

# `could not read file "%s": read %d of %d`

## What it means

`pg_waldump` read from a file but received fewer bytes than expected. The `%d` values give the bytes read against the amount requested. A short read means the file is truncated at that point.

## When it happens

It happens while `pg_waldump` reads WAL, when a read returns too few bytes — usually a partial or truncated WAL segment, sometimes the currently active segment being written.

## How to fix

Point `pg_waldump` at complete WAL segments, and avoid reading a segment that the server is still writing. If a segment is genuinely truncated, choose a range covered by intact segments.

## Example

*Illustrative* — a short read from a WAL file.

```text
pg_waldump: fatal: could not read file "000000010000000000000005": read 3000 of 8192
```

## Related

- [could not read file: read of](./could-not-read-file-read-of-ab7525.md)
- [could not read from file, offset: read of](./could-not-read-from-file-offset-read-of-2c49fa.md)
