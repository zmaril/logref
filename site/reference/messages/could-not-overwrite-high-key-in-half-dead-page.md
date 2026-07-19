---
message: "could not overwrite high key in half-dead page"
slug: could-not-overwrite-high-key-in-half-dead-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpage.c:2258"
reproduced: false
---

# `could not overwrite high key in half-dead page`

## What it means

B-tree page-deletion code tried to update the high key on a page it was retiring (a half-dead page, mid-deletion) and could not fit the new key. The high key bounds the range of entries a page may hold.

## When it happens

It fires during B-tree index maintenance while a page is being removed, when rewriting its high key does not fit — an internal invariant, usually a sign of a damaged index page.

## How to fix

This is an internal guard that generally indicates B-tree index corruption. Rebuild the index with `REINDEX`, and check the storage underneath for faults. If it recurs on a freshly rebuilt index, capture the log and report a reproducible case.

## Example

*Illustrative* — a high key that would not fit during page deletion.

```text
ERROR:  could not overwrite high key in half-dead page
```

## Related

- [could not open critical system index](./could-not-open-critical-system-index.md)
- [could not re-fetch previously fetched frame row](./could-not-re-fetch-previously-fetched-frame-row.md)
