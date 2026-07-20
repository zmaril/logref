---
message: "could not fit vacuumed posting list"
slug: could-not-fit-vacuumed-posting-list
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/gindatapage.c:782"
reproduced: false
---

# `could not fit vacuumed posting list`

## What it means

GIN vacuum rewrote a compressed posting list — the packed set of row pointers a GIN index stores per key — and the result no longer fit in the page it came from. Removing entries should never make a posting list larger, so the size math failed.

## When it happens

It fires while `VACUUM` cleans a GIN index, when repacking a posting list after deletions produces something too big for its page. This is an internal invariant, usually a sign of a damaged GIN page.

## How to fix

This is an internal guard. It generally indicates GIN index corruption. Rebuild the index with `REINDEX`, and check the storage underneath for faults. If it recurs on a freshly built index, capture the log and report a reproducible case.

## Example

*Illustrative* — a repacked posting list that no longer fits.

```text
ERROR:  could not fit vacuumed posting list
```

## Related

- [could not find additional pending pages for same heap tuple](./could-not-find-additional-pending-pages-for-same-heap-tuple.md)
- [could not find tuple using search from root page in index](./could-not-find-tuple-using-search-from-root-page-in-index.md)
