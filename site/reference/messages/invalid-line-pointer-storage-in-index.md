---
message: "invalid line pointer storage in index \"%s\""
slug: invalid-line-pointer-storage-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:785"
  - "postgres/contrib/amcheck/verify_nbtree.c:3515"
reproduced: false
---

# `invalid line pointer storage in index "%s"`

## What it means

An index page held a line pointer whose storage flags or length are inconsistent with a valid index tuple. It signals index page corruption.

## When it happens

It is reported by index verification (`amcheck`) or internal index reads when a page's item pointers do not describe a well-formed tuple. It points to a damaged index, not to user data.

## How to fix

Rebuild the index with `REINDEX INDEX`. If the problem returns, investigate storage: check the server log for I/O errors and verify the disk. Record the index name for follow-up.

## Example

*Illustrative* — a malformed line pointer on an index page.

```text
ERROR:  invalid line pointer storage in index "my_idx"
```

## Related

- [line pointer points past end of tuple space in index](./line-pointer-points-past-end-of-tuple-space-in-index.md)
- [index contains an inner tuple marked as invalid](./index-contains-an-inner-tuple-marked-as-invalid.md)
