---
message: "invalid ItemId"
slug: invalid-itemid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pageinspect/btreefuncs.c:504"
  - "postgres/contrib/pageinspect/gistfuncs.c:173"
  - "postgres/contrib/pageinspect/gistfuncs.c:278"
  - "postgres/contrib/pageinspect/hashfuncs.c:360"
reproduced: false
---

# `invalid ItemId`

## What it means

Internal error. Page-inspection code (here `pageinspect` for btree) read an item pointer (`ItemId`) on a page whose fields are inconsistent — a length, offset, or flags combination that cannot be valid. It is a structural check on a heap/index line pointer.

## When it happens

Inspecting a page (via `pageinspect`) that is corrupted, or an index scan encountering a damaged line pointer. It signals on-disk damage rather than a usage error.

## How to fix

Suspect corruption on the inspected relation/index. Verify with `amcheck`, and rebuild the index (`REINDEX`) or investigate the table if a heap page is involved. Look into storage/hardware health, since an invalid `ItemId` means the page contents are damaged.

## Example

*Illustrative* — pageinspect over a damaged page.

```text
ERROR:  invalid ItemId
```

## Related

- [index contains unexpected zero page at block](./index-contains-unexpected-zero-page-at-block.md)
- [invalid overflow block number](./invalid-overflow-block-number.md)
