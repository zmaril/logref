---
message: "could not determine seek position in archive file: %m"
slug: could-not-determine-seek-position-in-archive-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:757"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:811"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:953"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1007"
reproduced: false
---

# `could not determine seek position in archive file: %m`

## What it means

A tool (here `pg_dump`/`pg_restore` with the custom archive format) called `ftello()` to learn its position in the archive and it failed. The `%m` is the OS error. The tool needs the offset to build or read the archive's table of contents.

## When it happens

Reading or writing a custom-format archive on a stream that is not seekable — a pipe, a socket, or `stdin`/`stdout` — or when an I/O error prevents determining the position. The custom format requires a real, seekable file.

## How to fix

Use a regular file rather than a pipe for custom-format archives, so seeking works. If you must stream, use a format that supports non-seekable output. Read the `%m` text for an underlying I/O error and address that (storage, permissions).

## Example

*Illustrative* — a non-seekable custom-format archive.

```text
FATAL:  could not determine seek position in archive file: Illegal seek
```

## Related

- [could not read from input file](./could-not-read-from-input-file-3a7c6a.md)
- [could not open input file](./could-not-open-input-file-bea6ca.md)
