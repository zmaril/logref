---
message: "could not write file \"%s\": wrote %d of %d"
slug: could-not-write-file-wrote-of-c8a991
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:162"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:766"
reproduced: false
---

# `could not write file "%s": wrote %d of %d`

## What it means

`pg_combinebackup` wrote fewer bytes to a file than intended. The `%s` is the path and the counts are bytes written versus expected. A short write means the output was not fully persisted.

## When it happens

The output filesystem filled up or returned an I/O error while `pg_combinebackup` reconstructed a file or wrote the backup label.

## How to fix

Ensure the output directory has enough free space and healthy storage for the combined backup, then rerun. A short write leaves an incomplete output — discard it and retry to clean storage.

## Example

*Illustrative* — a short write during backup reconstruction.

```text
pg_combinebackup: error: could not write file "backup_label": wrote 200 of 512
```

## Related

- [could not write file: wrote only of bytes at offset](./could-not-write-file-wrote-only-of-bytes-at-offset-e8dd33.md)
- [could not read file](./could-not-read-file-read-of-a9ed38.md)
