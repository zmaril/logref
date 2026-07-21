---
message: "input page is not a valid GIN data leaf page"
slug: input-page-is-not-a-valid-gin-data-leaf-page
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/ginfuncs.c:120"
  - "postgres/contrib/pageinspect/ginfuncs.c:209"
reproduced: false
---

# `input page is not a valid GIN data leaf page`

## What it means

A GIN index inspection or internal routine was handed a page that does not have the layout of a GIN data leaf page. Either the wrong page was passed to a `pageinspect` function or the GIN index is corrupted.

## When it happens

It comes from GIN page-inspection functions (`gin_leafpage_items` and relatives) given a page that is not a data leaf, or from GIN internals meeting a page whose special area does not identify it as a GIN data leaf.

## How to fix

If you are calling a `pageinspect` GIN function, pass a page that really is a GIN data leaf page. If it occurs during normal index use, the index is likely damaged — rebuild it with `REINDEX INDEX` and check storage for I/O errors.

## Example

*Illustrative* — inspecting the wrong GIN page.

```text
ERROR:  input page is not a valid GIN data leaf page
```

## Related

- [number of items mismatch in GIN entry tuple](./number-of-items-mismatch-in-gin-entry-tuple-in-tuple-header-decoded.md)
- [index is not a btree](./index-is-not-a-btree.md)
