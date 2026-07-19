---
message: "cannot stream write-ahead logs in tar mode to stdout"
slug: cannot-stream-write-ahead-logs-in-tar-mode-to-stdout
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2692"
reproduced: false
---

# `cannot stream write-ahead logs in tar mode to stdout`

## What it means

`pg_basebackup` was asked to stream write-ahead logs while writing the backup as a tar archive to standard output. WAL streaming needs a second output stream, which cannot be interleaved with a tar archive on `stdout`, so the combination is rejected.

## When it happens

It occurs with `pg_basebackup -Ft -D -` (tar format to stdout) together with the default `--wal-method=stream`.

## How to fix

Write the backup to a directory instead of `stdout`, or switch to `--wal-method=fetch` so WAL is collected at the end rather than streamed alongside the archive.

## Example

*Illustrative* — tar to stdout with WAL streaming.

```text
pg_basebackup: error: cannot stream write-ahead logs in tar mode to stdout
```

## Related

- [cannot specify both format and backup target](./cannot-specify-both-format-and-backup-target.md)
- [cannot specify both output directory and backup target](./cannot-specify-both-output-directory-and-backup-target.md)
