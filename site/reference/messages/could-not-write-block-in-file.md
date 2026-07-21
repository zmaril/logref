---
message: "could not write block %u in file \"%s\": %m"
slug: could-not-write-block-in-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:262"
reproduced: false
---

# `could not write block %u in file "%s": %m`

## What it means

`pg_checksums` could not write a block back to a file while enabling or updating checksums. The placeholders are the block number and the file, and the trailing text is the operating-system error.

## When it happens

It fires while `pg_checksums` rewrites data blocks with computed checksums and a write fails — an I/O error, a full disk, or a permission problem on the data directory.

## How to fix

Read the OS error. `No space left on device` means the filesystem is full; free space and rerun. A permission problem means the user running `pg_checksums` cannot write the data directory. Confirm the server is shut down cleanly before running the tool, since it must have exclusive access.

## Example

*Illustrative* — a block write failed while enabling checksums.

```text
pg_checksums: error: could not write block 42 in file "base/1/1259": No space left on device
```

## Related

- [could not write block in file (short write)](./could-not-write-block-in-file-wrote-of.md)
- [could not write blocks in file](./could-not-write-blocks-in-file.md)
