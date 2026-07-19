---
message: "could not truncate file \"%s\" to %u blocks: %m"
slug: could-not-truncate-file-to-blocks
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1366"
reproduced: false
---

# `could not truncate file "%s" to %u blocks: %m`

## What it means

The storage manager could not truncate a relation file to a given number of blocks. The placeholders are the file and the block count, and the trailing text is the operating-system error. Truncating removes trailing blocks from a relation's storage.

## When it happens

It fires when the server shrinks a relation — for example after a vacuum frees empty trailing pages — and the truncate on the file fails.

## How to fix

Read the OS error. An I/O failure points at the storage holding the relation; check the disk and kernel log. A permission or read-only-filesystem problem is also possible. Address the underlying storage condition; the data itself is not implicated by a failed truncate.

## Example

*Illustrative* — a relation truncate failed.

```text
ERROR:  could not truncate file "base/16384/24576" to 100 blocks: Input/output error
```

## Related

- [could not truncate file to blocks: it's only N blocks now](./could-not-truncate-file-to-blocks-it-s-only-blocks-now.md)
- [could not truncate file to (rewriteheap)](./could-not-truncate-file-to-6f0e49.md)
