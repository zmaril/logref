---
message: "block 0 is a meta page"
slug: block-0-is-a-meta-page
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:245"
reproduced: false
---

# `block 0 is a meta page`

## What it means

A `pageinspect` function was asked to inspect block zero of an index whose first block is the meta page. The meta page holds index-wide bookkeeping rather than the tuples the function reads, so it is refused.

## When it happens

It occurs when calling a `pageinspect` function such as a B-tree page reader on block zero, which for many index types is reserved as the meta page.

## How to fix

Inspect a data block instead of block zero, or use the metadata-specific function such as `bt_metap` to read the meta page. Choose the `pageinspect` routine that matches the page you want to examine.

## Example

*Illustrative* — inspecting the meta page as data.

```sql
SELECT * FROM bt_page_items('my_index', 0);
```

## Related

- [block is a meta page](./block-is-a-meta-page.md)
- [block is not a valid btree leaf page](./block-is-not-a-valid-btree-leaf-page.md)
