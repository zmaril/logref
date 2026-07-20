---
message: "invalid overflow block number %u"
slug: invalid-overflow-block-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/hashfuncs.c:455"
  - "postgres/contrib/pageinspect/hashfuncs.c:461"
  - "postgres/contrib/pageinspect/hashfuncs.c:476"
  - "postgres/src/backend/access/hash/hashovfl.c:86"
reproduced: false
---

# `invalid overflow block number %u`

## What it means

A `pageinspect` hash-index function was given a block number that is not a valid overflow-page block for the index. The placeholder is the block number. Hash indexes have a specific page layout (metapage, buckets, overflow pages); asking to inspect a block that is not a valid overflow page is rejected.

## When it happens

Calling a `pageinspect` hash function with a block number that is out of range, points at a non-overflow page, or does not exist in the index.

## How to fix

Pass a block number that corresponds to an actual overflow page of the hash index. Use the extension's metadata/stat functions to find valid block numbers, and stay within the index's size. Verify you are inspecting a hash index.

## Example

*Illustrative* — a bad hash overflow block.

```text
ERROR:  invalid overflow block number 999
```

## Related

- [is not a index](./is-not-a-index.md)
- [invalid ItemId](./invalid-itemid.md)
