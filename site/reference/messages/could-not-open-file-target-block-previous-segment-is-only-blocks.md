---
message: "could not open file \"%s\" (target block %u): previous segment is only %u blocks"
slug: could-not-open-file-target-block-previous-segment-is-only-blocks
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1857"
reproduced: false
---

# `could not open file "%s" (target block %u): previous segment is only %u blocks`

## What it means

The storage manager tried to open a later segment of a relation to reach a target block, but the previous segment is shorter than a full segment — so the target block lies beyond where the relation's files actually end. The block numbers describe the gap.

## When it happens

It fires during table or index access when a block is requested past the real end of a relation whose earlier segment is not full-sized — usually a sign of a truncated or corrupted relation, or an inconsistency between the catalog and the on-disk files.

## How to fix

Treat this as possible relation corruption. Check the storage underneath for faults and confirm the relation's segment files are intact. If a segment was truncated or lost, restore the affected relation from a backup; capture the file names and block numbers for investigation.

## Example

*Illustrative* — a block requested past a short segment.

```text
ERROR:  could not open file "base/16384/16400.2" (target block 262144): previous segment is only 100 blocks
```

## Related

- [could not open file (target block)](./could-not-open-file-target-block.md)
- [could not read block in file](./could-not-read-block-in-file.md)
