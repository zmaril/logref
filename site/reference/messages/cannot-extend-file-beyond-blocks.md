---
message: "cannot extend file \"%s\" beyond %u blocks"
slug: cannot-extend-file-beyond-blocks
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:510"
  - "postgres/src/backend/storage/smgr/md.c:572"
reproduced: false
---

# `cannot extend file "%s" beyond %u blocks`

## What it means

A request to grow a relation's file would push it past the maximum number of blocks a single relation fork can hold. The placeholders are the file and the block limit. A relation fork cannot exceed roughly 4 billion blocks (32 TB at the default block size).

## When it happens

A single table or index fork growing to the hard block-count ceiling — an extreme case, or the result of a bug or corruption inflating the requested block number.

## How to fix

Reduce the size of the individual relation: partition a very large table so no single partition approaches the limit, archive or delete data, or rebuild bloated indexes. If the block number looks implausibly large, treat it as possible corruption and investigate the relation's on-disk state.

## Example

*Illustrative* — a relation fork at the block ceiling.

```text
ERROR:  cannot extend file "base/16384/98765" beyond 4294967295 blocks
```

## Related

- [could not extend file](./could-not-extend-file.md)
- [cannot open relation](./cannot-open-relation.md)
