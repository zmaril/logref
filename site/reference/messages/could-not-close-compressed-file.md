---
message: "could not close compressed file \"%s\": %m"
slug: could-not-close-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_gzip.c:191"
reproduced: false
---

# `could not close compressed file "%s": %m`

## What it means

A tool reading or writing a gzip-compressed stream could not close the compressed file. The `%m` reason gives the OS error. The close failed, so the file may be incomplete.

## When it happens

It happens in `pg_basebackup`/`pg_dump` gzip paths when closing a `.gz` file fails, generally due to a filesystem or disk problem.

## How to fix

Check the destination filesystem for space, permissions, and errors. Resolve the underlying storage issue and regenerate the file; a compressed file that failed to close cannot be relied upon.

## Example

*Illustrative* — a failed compressed-file close.

```text
pg_basebackup: fatal: could not close compressed file "...": ...
```

## Related

- [could not close compression stream](./could-not-close-compression-stream.md)
- [could not close compression library](./could-not-close-compression-library.md)
