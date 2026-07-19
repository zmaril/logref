---
message: "could not split GIN page; all old items didn't fit"
slug: could-not-split-gin-page-all-old-items-didn-t-fit
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/gindatapage.c:580"
reproduced: false
---

# `could not split GIN page; all old items didn't fit`

## What it means

A GIN index page split failed because the existing items alone would not fit into the two resulting pages. GIN posting pages hold item pointers, and a split must divide them across a new pair of pages; here even the old items overflowed. This is an internal invariant.

## When it happens

It fires during GIN index maintenance when a page split cannot place the current items, which on a healthy index and build should not occur.

## How to fix

This is an internal guard rather than a user error. If it appears, it suggests an unexpected item layout or possible index corruption. Try `REINDEX` on the affected GIN index to rebuild it cleanly. If it recurs, capture the index definition and the surrounding log and report it.

## Example

*Illustrative* — a GIN page split could not place the old items.

```text
ERROR:  could not split GIN page; all old items didn't fit
```

## Related

- [could not split GIN page; no new items fit](./could-not-split-gin-page-no-new-items-fit.md)
- [cross page item order invariant violated for index](./cross-page-item-order-invariant-violated-for-index.md)
