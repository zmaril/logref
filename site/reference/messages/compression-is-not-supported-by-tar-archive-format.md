---
message: "compression is not supported by tar archive format"
slug: compression-is-not-supported-by-tar-archive-format
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:194"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:330"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:385"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:401"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:906"
reproduced: false
---

# `compression is not supported by tar archive format`

## What it means

`pg_dump` was asked to compress output while also using the `tar` archive format. The `tar` format does not support internal compression the way the custom and directory formats do, so the combination is rejected.

## When it happens

Running `pg_dump -F t` (tar format) together with a compression option such as `-Z`/`--compress`.

## How to fix

Use a format that supports compression — the custom (`-F c`) or directory (`-F d`) format with `--compress`. If you must produce a tar archive, drop the compression option and compress the resulting file externally (for example pipe through `gzip`).

## Example

*Illustrative* — compression requested with tar format.

```sh
pg_dump -F t -Z 9 mydb > db.tar
```

## Related

- [could not decompress data](./could-not-decompress-data.md)
- [invalid compression specification](./invalid-compression-specification.md)
