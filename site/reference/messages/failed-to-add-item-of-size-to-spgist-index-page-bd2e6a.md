---
message: "failed to add item of size %zu to SPGiST index page"
slug: failed-to-add-item-of-size-to-spgist-index-page-bd2e6a
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/access/spgist/spgutils.c:1272"
  - "postgres/src/backend/access/spgist/spgutils.c:1284"
reproduced: false
---

# `failed to add item of size %zu to SPGiST index page`

## What it means

Internal error. An SPGiST page could not accept an item of a given size. The `%zu` is the item size. It is a consistency guard in SPGiST maintenance; at some sites it is raised as PANIC during WAL replay.

## When it happens

It fires during SPGiST index maintenance or recovery when a page lacked the space the code computed. Ordinary queries do not raise it; it can accompany index or page corruption.

## How to fix

Reindex the affected SPGiST index. If it appears during recovery (PANIC), suspect page/WAL corruption and check storage; restore from backup if needed. Capture the index name and report a reproducible case.

## Example

*Illustrative* — an SPGiST item did not fit its page.

```text
ERROR:  failed to add item of size 200 to SPGiST index page
```

## Related

- [failed to divide leaf tuple groups across pages](./failed-to-divide-leaf-tuple-groups-across-pages.md)
- [failed to find requested node in SPGiST inner tuple](./failed-to-find-requested-node-in-spgist-inner-tuple.md)
