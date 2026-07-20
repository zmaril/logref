---
message: "could not copy file \"%s\" to \"%s\": %m"
slug: could-not-copy-file-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:314"
reproduced: false
---

# `could not copy file "%s" to "%s": %m`

## What it means

`pg_combinebackup` could not copy a file from a source backup into the reconstructed output directory. The `%m` reason gives the OS error.

## When it happens

It happens while combining incremental backups when copying one of the input files fails, usually from a full output filesystem, a permissions problem, or an I/O error.

## How to fix

Check free space and permissions on the output directory and the health of both source and destination storage. Resolve the problem and rerun `pg_combinebackup`; a partial output directory should be discarded.

## Example

*Illustrative* — a copy failing during backup combination.

```text
pg_combinebackup: fatal: could not copy file "base/1/1259" to "out/base/1/1259": No space left on device
```

## Related

- [could not copy file range between old and new data directories](./could-not-copy-file-range-between-old-and-new-data-directories.md)
- [could not create link from to](./could-not-create-link-from-to.md)
