---
message: "could not find parent of block %u in lookup table"
slug: could-not-find-parent-of-block-in-lookup-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistbuild.c:1578"
reproduced: false
---

# `could not find parent of block %u in lookup table`

## What it means

During a GiST index build, the builder could not find the parent of a block in its in-memory lookup table. The `%u` is the block. This is an internal consistency check of the buffered GiST build.

## When it happens

It fires while building a GiST index with buffering. Reaching it points at an internal problem rather than anything in the data.

## How to fix

This is an internal error. As a workaround, building the index without buffering (`CREATE INDEX ... WITH (buffering = off)`) avoids this code path. Note the index and report a reproducible case.

## Example

*Illustrative* — a missing parent during GiST build.

```text
ERROR:  could not find parent of block 42 in lookup table
```

## Related

- [could not find left sibling of block in index](./could-not-find-left-sibling-of-block-in-index.md)
- [could not find additional pending pages for same heap tuple](./could-not-find-additional-pending-pages-for-same-heap-tuple.md)
