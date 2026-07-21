---
message: "block is a meta page"
slug: block-is-a-meta-page
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:779"
reproduced: false
---

# `block is a meta page`

## What it means

A `pageinspect` function was pointed at a block that is the index's meta page, but the function reads data pages. The meta page stores index-wide metadata, not the items the function decodes.

## When it happens

It occurs when a `pageinspect` routine is given the meta-page block number instead of a data block.

## How to fix

Pass a data-page block number, or use the metadata function such as `bt_metap` to read the meta page. Match the `pageinspect` function to the kind of page you are inspecting.

## Example

*Illustrative* — a data reader on the meta page.

```text
ERROR:  block is a meta page
```

## Related

- [block 0 is a meta page](./block-0-is-a-meta-page.md)
- [block is not a valid btree leaf page](./block-is-not-a-valid-btree-leaf-page.md)
