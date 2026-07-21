---
message: "error during writing: %s"
slug: error-during-writing-be913d
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:549"
reproduced: false
---

# `error during writing: %s`

## What it means

`pg_dump` hit an error while writing LZ4-compressed output, reported by the LZ4 library rather than the OS. The placeholder is the library error string.

## When it happens

It fires in `pg_dump` while producing an LZ4-compressed archive, when the LZ4 compression step reports a failure writing its output.

## How to fix

Check the LZ4 error text and the destination. A full or failing filesystem is the usual root cause even when the message comes from the library; free space or fix the storage. If the error indicates a library problem, verify the `pg_dump` build's LZ4 support.

## Example

*Illustrative* — an LZ4-reported write error.

```text
pg_dump: error: error during writing: ...
```

## Related

- [error during writing](./error-during-writing-929603.md)
- [error reading large object](./error-reading-large-object.md)
