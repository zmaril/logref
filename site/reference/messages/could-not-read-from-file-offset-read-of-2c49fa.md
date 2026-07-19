---
message: "could not read from file \"%s\", offset %d: read %d of %d"
slug: could-not-read-from-file-offset-read-of-2c49fa
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:437"
reproduced: false
---

# `could not read from file "%s", offset %d: read %d of %d`

## What it means

`pg_waldump` read from a WAL file at a given offset but received fewer bytes than expected. The `%d` values give the bytes read against the amount requested. A short read means the segment is truncated at that offset.

## When it happens

It happens while `pg_waldump` reads WAL, when a read at an offset returns too few bytes — usually a partial or truncated segment, sometimes the active segment being written.

## How to fix

Read complete WAL segments and avoid a segment the server is still writing. If a segment is genuinely truncated, choose a range covered by intact segments.

## Example

*Illustrative* — a short read at an offset.

```text
pg_waldump: fatal: could not read from file "000000010000000000000005", offset 4194304: read 100 of 8192
```

## Related

- [could not read from file, offset](./could-not-read-from-file-offset.md)
- [could not read from file, offset: read of](./could-not-read-from-file-offset-read-of-8bb91d.md)
