---
message: "could not set seek position in archive file: %m"
slug: could-not-set-seek-position-in-archive-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:823"
reproduced: false
---

# `could not set seek position in archive file: %m`

## What it means

`pg_dump` or `pg_restore` could not set the read position in a custom-format archive file. The trailing text is the operating-system error. The custom format seeks around the archive to reach specific data blocks.

## When it happens

It fires while the tool reads a custom-format archive and repositions to a block, when the seek fails — an I/O error, or an archive that is not seekable (for example one piped through a stream).

## How to fix

Make sure the archive is a real file on disk, since seeking does not work on pipes. Read the OS error for I/O or permission problems. If the archive was truncated in transit, re-copy it and confirm its size before restoring.

## Example

*Illustrative* — seeking within a custom archive failed.

```text
pg_restore: error: could not set seek position in archive file: Illegal seek
```

## Related

- [could not read input file](./could-not-read-input-file.md)
- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
