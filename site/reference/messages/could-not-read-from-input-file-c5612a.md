---
message: "could not read from input file: %m"
slug: could-not-read-from-input-file-c5612a
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:323"
  - "postgres/src/bin/pg_dump/compress_lz4.c:470"
  - "postgres/src/bin/pg_dump/compress_none.c:154"
  - "postgres/src/bin/pg_dump/compress_none.c:195"
  - "postgres/src/bin/pg_dump/compress_zstd.c:313"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:657"
  - "postgres/src/bin/psql/input.c:215"
reproduced: false
---

# `could not read from input file: %m`

## What it means

A tool reading an input stream got an OS-level read error. The `%m` is the error string. Unlike the end-of-file variant, here the `read()` itself failed rather than the stream ending early.

## When it happens

`pg_restore` or a decompressing reader hitting a failing file descriptor, storage error, or (for stdin) a broken pipe. Common `%m`: `Input/output error`, `Bad file descriptor`, or a pipe error when the producer died.

## How to fix

Read `%m`. `Input/output error` points at failing storage — check the disk holding the input. A broken pipe means the process feeding the input exited; check that side. Re-run once the underlying I/O problem is fixed, from a known-good input file.

## Example

*Illustrative* — a restore input on failing storage.

```text
pg_restore: error: could not read from input file: Input/output error
```

## Related

- [could not read from input file: end of file](./could-not-read-from-input-file-end-of-file.md)
- [could not read from file](./could-not-read-from-file.md)
