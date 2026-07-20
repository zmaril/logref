---
message: "could not truncate file \"%s\" to %u blocks: it's only %u blocks now"
slug: could-not-truncate-file-to-blocks-it-s-only-blocks-now
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1312"
reproduced: false
---

# `could not truncate file "%s" to %u blocks: it's only %u blocks now`

## What it means

The server tried to truncate a relation file to a block count larger than the file's current size. The placeholders report the requested block count and the file's actual current block count. A truncate is only meant to shrink, so this is a consistency check.

## When it happens

It fires when the server's idea of a relation's length is ahead of what is on disk — the file is already shorter than the target of the truncate. This points at an inconsistency between the cached relation size and the actual file.

## How to fix

This is an internal consistency guard and can indicate that the file was truncated out from under the server or that the storage state is inconsistent. Check the storage for signs of external modification or corruption. Preserve the log and, if it persists, investigate the relation with the block numbers named in the message.

## Example

*Illustrative* — the file was already shorter than the target.

```text
ERROR:  could not truncate file "base/16384/24576" to 200 blocks: it's only 150 blocks now
```

## Related

- [could not truncate file to blocks](./could-not-truncate-file-to-blocks.md)
- [could not start reading blocks in file](./could-not-start-reading-blocks-in-file.md)
