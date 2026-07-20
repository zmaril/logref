---
message: "could not read from input file: end of file"
slug: could-not-read-from-input-file-end-of-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:325"
  - "postgres/src/bin/pg_dump/compress_lz4.c:586"
  - "postgres/src/bin/pg_dump/compress_none.c:197"
  - "postgres/src/bin/pg_dump/compress_zstd.c:400"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:655"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:515"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:740"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:763"
reproduced: false
---

# `could not read from input file: end of file`

## What it means

A tool reading a compressed or structured input stream hit end-of-file before it expected to — the input is truncated. Decompressors (`gzip`, `lz4`, `zstd`, or the plain reader) need a complete stream and report premature EOF as fatal.

## When it happens

`pg_restore` or a WAL/backup reader consuming an archive that was cut short — an interrupted copy, a truncated dump file, or a stream that ended mid-record. It indicates the input file is incomplete, not that reading failed at the OS level.

## How to fix

Obtain a complete, untruncated input file. Verify the dump/archive transferred fully (compare sizes/checksums against the source). If it was produced by an interrupted `pg_dump`, regenerate it. A truncated compressed stream cannot be recovered — you need the full file.

## Example

*Illustrative* — restoring a truncated custom-format dump.

```sh
pg_restore -d mydb truncated.dump
```

Produces:

```text
pg_restore: error: could not read from input file: end of file
```

## Related

- [could not read from input file: %m](./could-not-read-from-input-file-c5612a.md)
- [could not read file: read %d of %zu](./could-not-read-file-read-of-345e80.md)
