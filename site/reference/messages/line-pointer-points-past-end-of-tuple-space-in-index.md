---
message: "line pointer points past end of tuple space in index \"%s\""
slug: line-pointer-points-past-end-of-tuple-space-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:769"
  - "postgres/contrib/amcheck/verify_nbtree.c:3499"
reproduced: false
---

# `line pointer points past end of tuple space in index "%s"`

## What it means

An index page held a line pointer whose offset or length extends beyond the page's usable tuple area. It signals index page corruption.

## When it happens

It is reported by index verification (`amcheck`) or internal index reads when an item pointer references storage outside the page bounds. It points to a damaged index, not to user data.

## How to fix

Rebuild the index with `REINDEX INDEX`. If the error persists, investigate the storage layer: review the log for I/O errors and check the disk. Note the index name for follow-up.

## Example

*Illustrative* — a line pointer past the page's tuple space.

```text
ERROR:  line pointer points past end of tuple space in index "my_idx"
```

## Related

- [invalid line pointer storage in index](./invalid-line-pointer-storage-in-index.md)
- [index contains an inner tuple marked as invalid](./index-contains-an-inner-tuple-marked-as-invalid.md)
