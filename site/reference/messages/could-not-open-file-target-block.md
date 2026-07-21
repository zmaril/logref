---
message: "could not open file \"%s\" (target block %u): %m"
slug: could-not-open-file-target-block
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1871"
reproduced: false
---

# `could not open file "%s" (target block %u): %m`

## What it means

The storage manager tried to open a data file segment while reading or writing a specific block and the operating system refused. The `%m` reason gives the cause. Large relations are split into segment files, and the segment holding the target block could not be opened.

## When it happens

It fires during normal table or index access when a relation segment file cannot be opened — usually a missing or unreadable segment, a permissions change, or an I/O error on the data directory.

## How to fix

Check the data directory's permissions and storage health for the affected relation's files. A missing segment for an existing relation indicates corruption or accidental file removal; investigate the storage and, if files are lost, restore from a backup.

## Example

*Illustrative* — a relation segment could not be opened.

```text
ERROR:  could not open file "base/16384/16400.1" (target block 131072): No such file or directory
```

## Related

- [could not open file (target block): previous segment is only blocks](./could-not-open-file-target-block-previous-segment-is-only-blocks.md)
- [could not prefetch relation block](./could-not-prefetch-relation-block.md)
