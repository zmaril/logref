---
message: "desired SPGiST tuple size is too big"
slug: desired-spgist-tuple-size-is-too-big
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgutils.c:575"
reproduced: false
---

# `desired SPGiST tuple size is too big`

## What it means

An internal SP-GiST guard. The index code computed a tuple size that exceeds what a page can hold. SP-GiST tuples must fit within a page, and this value did not.

## When it happens

It fires during SP-GiST index build or insert when an inner or leaf tuple would be larger than the page allows, typically because an operator class produced an oversize key.

## How to fix

This is usually an operator-class limitation rather than a user error. If you hit it indexing very large values, index a smaller derived value instead (for example a prefix or hash). For a custom SP-GiST operator class, review how it sizes tuples.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  desired SPGiST tuple size is too big
```

## Related

- [could not split GIN page; all old items didn't fit](./could-not-split-gin-page-all-old-items-didn-t-fit.md)
- [deduplication failed to add heap tid to pending posting list](./deduplication-failed-to-add-heap-tid-to-pending-posting-list.md)
