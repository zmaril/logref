---
message: "compressor active"
slug: compressor-active
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:902"
reproduced: false
---

# `compressor active`

## What it means

The custom-format dump writer found a compressor already active when it expected none. This is an internal state check in `pg_dump`'s custom archive writer; it indicates the archive code reached an unexpected state.

## When it happens

It fires inside `pg_dump` custom-format output when a new data block is started while a compression stream from a previous block was still open.

## How to fix

This is an internal error, not a user option. Retry the dump; if it recurs, capture the exact `pg_dump` command and version and report it. Check for interrupted or corrupted output that might have left the writer mid-stream.

## Example

*Illustrative* — an unexpected active compressor in pg_dump.

```text
pg_dump: error: compressor active
```

## Related

- [compression with is not yet supported](./compression-with-is-not-yet-supported.md)
- [could not close compression stream](./could-not-close-compression-stream.md)
