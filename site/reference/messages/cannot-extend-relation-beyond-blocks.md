---
message: "cannot extend relation %s beyond %u blocks"
slug: cannot-extend-relation-beyond-blocks
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/storage/buffer/localbuf.c:401"
reproduced: false
---

# `cannot extend relation %s beyond %u blocks`

## What it means

A relation could not grow because it reached the maximum number of blocks a single fork can hold. A table or index fork is addressed by a 32-bit block number, so it cannot exceed roughly 4 billion blocks (32 TB at the default 8 KB block size). The placeholders are the relation name and the block limit.

## When it happens

It occurs when a very large table or index — often a temporary or local buffer relation — fills its entire block-number space during a bulk load, a large sort, or unbounded growth.

## How to fix

Reduce the size of the single relation: partition the table so data spreads across many relations, split the load, or increase the block size at initdb time for a new cluster. For temporary spill, lower the working-set size so the relation does not grow so large.

## Example

*Illustrative* — a relation at its block limit.

```text
ERROR:  cannot extend relation base/16384/t3_98304 beyond 4294967295 blocks
```

## Related

- [cannot have more than runs for an external sort](./cannot-have-more-than-runs-for-an-external-sort.md)
- [cannot insert oversize tuple of size on internal page of index](./cannot-insert-oversized-tuple-of-size-on-internal-page-of-index.md)
