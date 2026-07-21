---
message: "could not split GIN page; no new items fit"
slug: could-not-split-gin-page-no-new-items-fit
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/gindatapage.c:589"
reproduced: false
---

# `could not split GIN page; no new items fit`

## What it means

A GIN index page split failed because no room was left for the new items after dividing the page. This is the companion to the old-items case: the split placed the existing items but could not fit the additions. It is an internal invariant.

## When it happens

It fires during GIN index maintenance when a page split cannot accommodate the items being inserted, which should not happen on a correct index and build.

## How to fix

This is an internal guard. Rebuilding the index with `REINDEX` is the practical first step, since it produces a clean page layout. If the error returns on a freshly rebuilt index, capture the index definition and log details and report it.

## Example

*Illustrative* — a GIN page split left no room for new items.

```text
ERROR:  could not split GIN page; no new items fit
```

## Related

- [could not split GIN page; all old items didn't fit](./could-not-split-gin-page-all-old-items-didn-t-fit.md)
- [cross page item order invariant violated for index](./cross-page-item-order-invariant-violated-for-index.md)
