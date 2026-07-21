---
message: "could not write to file \"%s\", wrote %d of %d: %m"
slug: could-not-write-to-file-wrote-of
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/rewriteheap.c:886"
reproduced: false
---

# `could not write to file "%s", wrote %d of %d: %m`

## What it means

The heap-rewrite code could not fully write to a file. The placeholders are the file and the bytes written versus expected, and the trailing text is the operating-system error. Rewriting a heap (for example during `VACUUM FULL` or `CLUSTER`) writes a new relation file.

## When it happens

It fires while the server rewrites a table's storage and a write to the new file falls short or fails — a full disk or an I/O error.

## How to fix

Read the OS error. `No space left on device` means the data directory's filesystem is full; a table rewrite needs room for a second copy of the data, so ensure there is enough free space. An I/O error points at the storage. Free space or fix the disk and rerun.

## Example

*Illustrative* — a heap-rewrite write fell short.

```text
ERROR:  could not write to file "base/16384/t3_98765", wrote 4096 of 8192: No space left on device
```

## Related

- [could not truncate file to (rewriteheap)](./could-not-truncate-file-to-6f0e49.md)
- [could not write blocks in file](./could-not-write-blocks-in-file.md)
