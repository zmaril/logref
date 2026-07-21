---
message: "can't traverse from downlink %u to downlink %u of index \"%s\""
slug: can-t-traverse-from-downlink-to-downlink-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2207"
reproduced: false
---

# `can't traverse from downlink %u to downlink %u of index "%s"`

## What it means

`amcheck` followed a downlink in an index and could not reach the expected child, so it could not traverse from one downlink to the next. The placeholders are the two block numbers and the index. Broken downlinks indicate structural corruption. It applies to indexes whose verification walks downlinks.

## When it happens

It occurs during `amcheck` verification of a damaged index.

## How to fix

Rebuild the index with `REINDEX` and investigate the corruption source — storage, hardware, or a crash. Verify related indexes for the same fault.

## Example

*Illustrative* — a broken downlink traversal.

```text
ERROR:  can't traverse from downlink 40 to downlink 55 of index "my_index"
```

## Related

- [can't find left sibling high key in index](./can-t-find-left-sibling-high-key-in-index.md)
- [block fell off the end of index](./block-fell-off-the-end-of-index.md)
