---
message: "failed to add item of size %u to SPGiST index page"
slug: failed-to-add-item-of-size-to-spgist-index-page-63086a
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:169"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:278"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1342"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1548"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1656"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1819"
  - "postgres/src/backend/access/spgist/spgxlog.c:69"
  - "postgres/src/backend/access/spgist/spgxlog.c:133"
  - "postgres/src/backend/access/spgist/spgxlog.c:313"
  - "postgres/src/backend/access/spgist/spgxlog.c:393"
  - "postgres/src/backend/access/spgist/spgxlog.c:509"
reproduced: false
---

# `failed to add item of size %u to SPGiST index page`

## What it means

Internal error. An SP-GiST index build or insert tried to place an item on an index page and the page manager refused it. The placeholder is the item size. It usually means an item is too large for a page, or an SP-GiST page accounting bug.

## When it happens

Inserting into or building an SP-GiST index where a single index tuple is too big for a page, or a bug in a custom SP-GiST operator class that produces oversized inner/leaf tuples. Ordinary use of the built-in opclasses rarely hits it.

## How to fix

If a custom SP-GiST opclass is involved, suspect it — its `choose`/`picksplit`/leaf functions may produce items that do not fit. For built-in opclasses, an item that large suggests unusually large indexed values; index a smaller expression or a prefix instead. Reproducible cases against a specific opclass and data should be reported.

## Example

*Illustrative* — an oversized SP-GiST leaf item.

```text
ERROR:  failed to add item of size 8160 to SPGiST index page
```

## Related

- [failed to add item to index page in](./failed-to-add-item-to-index-page-in-a87626.md)
- [index row size %zu exceeds maximum](./index-row-size-exceeds-maximum-for-index-8f3043.md)
