---
message: "error while copying file range from \"%s\" to \"%s\": %m"
slug: error-while-copying-file-range-from-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:292"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:706"
reproduced: false
---

# `error while copying file range from "%s" to "%s": %m`

## What it means

`pg_combinebackup` failed while copying a byte range from one file to another. The two `%s` values are the source and destination and the `%m` is the operating-system error. Reconstruction of the output file could not proceed.

## When it happens

An I/O error, an out-of-space condition, or an unsupported `copy_file_range` operation occurred while combining incremental backups into a full one.

## How to fix

Read the trailing error. Ensure the output filesystem has space and healthy storage. If `copy_file_range` is unsupported on the target filesystem, use a different destination that supports normal copying.

## Example

*Illustrative* — a file-range copy failed mid-reconstruction.

```text
pg_combinebackup: error: error while copying file range from "a" to "b": Input/output error
```

## Related

- [error while copying relation: could not create file](./error-while-copying-relation-could-not-create-file.md)
- [could not write file: wrote of](./could-not-write-file-wrote-of-c8a991.md)
