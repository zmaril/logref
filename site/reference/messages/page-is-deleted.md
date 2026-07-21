---
message: "page is deleted"
slug: page-is-deleted
passthrough: false
api: [elog]
level: [NOTICE]
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:789"
  - "postgres/contrib/pageinspect/gistfuncs.c:155"
  - "postgres/contrib/pageinspect/gistfuncs.c:258"
reproduced: false
---

# `page is deleted`

## What it means

A notice from a page-inspection function, reporting that the index page being examined is marked deleted. Deleted pages are empty pages awaiting recycling, and the notice explains why the tool returned little or no content for that page.

## When it happens

Inspecting an index page with a `pageinspect` function (for a btree or GiST index) that happens to be a deleted page — a normal transient state as the index reclaims space.

## Is this a problem?

No action is needed. A deleted index page is a normal part of how indexes recycle space; the notice simply reports the page's state. Inspect a different page if you need populated content.

## Example

*Illustrative* — inspecting a deleted index page.

```text
NOTICE:  page is deleted
```

## Related

- [block number is out of range for relation](./block-number-is-out-of-range-for-relation.md)
- [invalid index offnum](./invalid-index-offnum.md)
