---
message: "failed to divide leaf tuple groups across pages"
slug: failed-to-divide-leaf-tuple-groups-across-pages
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1108"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1113"
reproduced: false
---

# `failed to divide leaf tuple groups across pages`

## What it means

Internal error during an SPGiST page split. The code could not distribute leaf tuple groups across the resulting pages. It is a consistency guard in the SPGiST insertion path.

## When it happens

It fires during SPGiST index maintenance when a split could not partition its tuples as the algorithm expected. Ordinary queries do not raise it; it can accompany index corruption.

## How to fix

Reindex the affected SPGiST index. If it recurs, check storage health and capture the index and a reproducible case for a bug report.

## Example

*Illustrative* — an SPGiST split could not divide its groups.

```text
ERROR:  failed to divide leaf tuple groups across pages
```

## Related

- [failed to add item of size to SPGiST index page](./failed-to-add-item-of-size-to-spgist-index-page-bd2e6a.md)
- [failed to find requested node in SPGiST inner tuple](./failed-to-find-requested-node-in-spgist-inner-tuple.md)
