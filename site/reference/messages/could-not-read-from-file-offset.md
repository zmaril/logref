---
message: "could not read from file \"%s\", offset %d: %m"
slug: could-not-read-from-file-offset
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:433"
reproduced: false
---

# `could not read from file "%s", offset %d: %m`

## What it means

`pg_waldump` tried to read from a WAL file at a specific offset and the read failed. The `%m` reason gives the cause. It reads WAL at computed offsets to decode records.

## When it happens

It happens while `pg_waldump` reads a WAL segment, when a read at an offset fails — usually a truncated or missing segment, or an I/O error on the WAL storage.

## How to fix

Point `pg_waldump` at complete, readable WAL segments and avoid reading a segment the server is still writing. Check the storage if reads fail on segments that should be intact.

## Example

*Illustrative* — a read at an offset failed.

```text
pg_waldump: fatal: could not read from file "000000010000000000000005", offset 4194304: Input/output error
```

## Related

- [could not read from file, offset: read of](./could-not-read-from-file-offset-read-of-2c49fa.md)
- [could not locate WAL file](./could-not-locate-wal-file.md)
