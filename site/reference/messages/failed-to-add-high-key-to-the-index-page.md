---
message: "failed to add high key to the index page"
slug: failed-to-add-high-key-to-the-index-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtsort.c:940"
reproduced: false
---

# `failed to add high key to the index page`

## What it means

An internal guard during B-tree index build. While writing out a newly built index page, the code could not add the page's high key. The high key delimits the range of keys the page covers, and it did not fit as computed.

## When it happens

It fires while building a B-tree index (for example during `CREATE INDEX` or `REINDEX`). It generally indicates an unexpected internal condition, occasionally tied to unusually large keys or an on-disk or memory fault.

## How to fix

This is an internal invariant, not a user setting. Check for oversize index keys (values close to the B-tree per-tuple size limit) in the indexed columns, since very large keys can stress page layout. Confirm storage and memory health. If the index definition is ordinary, capture it and report the failure.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add high key to the index page
```

## Related

- [failed to add high key to left page after split](./failed-to-add-high-key-to-left-page-after-split.md)
- [failed to add item to the index page](./failed-to-add-item-to-the-index-page.md)
