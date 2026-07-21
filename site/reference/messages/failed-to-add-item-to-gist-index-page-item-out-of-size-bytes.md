---
message: "failed to add item to GiST index page, item %d out of %d, size %zu bytes"
slug: failed-to-add-item-to-gist-index-page-item-out-of-size-bytes
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistutil.c:49"
reproduced: false
---

# `failed to add item to GiST index page, item %d out of %d, size %zu bytes`

## What it means

An internal guard in GiST index handling. Writing an item onto a GiST index page, the code could not place it. The placeholders are the item's position, the total item count, and its size in bytes. The item did not fit where the layout expected.

## When it happens

It fires while building or updating a GiST index if an item cannot be added to a page as computed. It can indicate an unexpected internal condition, sometimes involving an unusually large indexed value for the operator class in use.

## How to fix

This is an internal invariant. Check whether the indexed values are unusually large for the GiST operator class, and confirm the operator class supports the data you are indexing. Verify storage health and rebuild the index with `REINDEX`. If the definition and data are ordinary, capture them and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add item to GiST index page, item 3 out of 5, size 2200 bytes
```

## Related

- [failed to add item to index page in](./failed-to-add-item-to-index-page-in-920554.md)
- [failed to add item to the index page](./failed-to-add-item-to-the-index-page.md)
