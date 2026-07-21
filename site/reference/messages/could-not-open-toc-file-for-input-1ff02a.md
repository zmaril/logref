---
message: "could not open TOC file for input: %m"
slug: could-not-open-toc-file-for-input-1ff02a
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:209"
reproduced: false
---

# `could not open TOC file for input: %m`

## What it means

`pg_restore` reading a tar-format archive from standard input tried to open its table-of-contents stream and could not. The `%m` reason gives the cause. This variant applies when no file name is available because input comes from a stream.

## When it happens

It happens during a tar-format restore that reads from standard input, when the TOC cannot be read from the stream — usually a truncated or non-tar input, or a broken pipe.

## How to fix

Make sure the data piped into `pg_restore` is a complete tar-format archive, and prefer restoring from a named file with `-f`/a path when possible so the tool can seek. A corrupted or partial stream must be re-produced.

## Example

*Illustrative* — the TOC could not be read from the input stream.

```text
pg_restore: fatal: could not open TOC file for input: Bad file descriptor
```

## Related

- [could not open TOC file for input](./could-not-open-toc-file-for-input-bafa4b.md)
- [could not open TOC file for output](./could-not-open-toc-file-for-output-50df44.md)
