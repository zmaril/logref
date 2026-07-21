---
message: "block is not a valid btree leaf page"
slug: block-is-not-a-valid-btree-leaf-page
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:784"
reproduced: false
---

# `block is not a valid btree leaf page`

## What it means

A `pageinspect` function that reads B-tree leaf items was given a page that is not a leaf — an internal or meta page, or a page from a different index type. The function only decodes leaf pages.

## When it happens

It occurs when calling a leaf-oriented `pageinspect` routine on a non-leaf block, or on a block from an index that is not a B-tree.

## How to fix

Point the function at a B-tree leaf block, or use a routine appropriate to the page type. Use `bt_page_stats` to find leaf pages, and confirm the index is a B-tree before reading its leaf items.

## Example

*Illustrative* — a non-leaf page passed to a leaf reader.

```text
ERROR:  block is not a valid btree leaf page
```

## Related

- [block is a meta page](./block-is-a-meta-page.md)
- [block 0 is a meta page](./block-0-is-a-meta-page.md)
