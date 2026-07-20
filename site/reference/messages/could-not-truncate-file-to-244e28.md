---
message: "could not truncate file \"%s\" to %u: %m"
slug: could-not-truncate-file-to-244e28
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:231"
reproduced: false
---

# `could not truncate file "%s" to %u: %m`

## What it means

`pg_rewind` could not truncate a file in the target to a given length. The placeholders are the file and the target length, and the trailing text is the operating-system error. Truncating trims a file to match the source.

## When it happens

It fires while `pg_rewind` shrinks a file in the target data directory to align it with the source, when the truncate operation fails.

## How to fix

Read the OS error. A permission problem means the user running `pg_rewind` cannot modify the target; an I/O error points at the storage. Ensure the target server is shut down cleanly and the directory is writable, then rerun.

## Example

*Illustrative* — a target-file truncate failed.

```text
pg_rewind: error: could not truncate file "base/1/1259" to 8192: Permission denied
```

## Related

- [could not truncate file to (rewriteheap)](./could-not-truncate-file-to-6f0e49.md)
- [could not seek in target file](./could-not-seek-in-target-file.md)
