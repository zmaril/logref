---
message: "failed to add high key to left page after split"
slug: failed-to-add-high-key-to-left-page-after-split
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:368"
reproduced: false
---

# `failed to add high key to left page after split`

## What it means

An internal guard in B-tree WAL replay. Reconstructing a page split during recovery, the code could not place the high key on the left page. The high key bounds the keys a page may hold; failing to add it means the reconstructed page did not fit as expected.

## When it happens

It fires during recovery or WAL replay of a B-tree page split. It usually signals damaged WAL or an on-disk inconsistency in the index rather than a user action.

## How to fix

This is an internal invariant tied to recovery. Confirm the WAL stream is intact and storage is healthy. After recovery, rebuild the affected index with `REINDEX`. If it recurs or recovery cannot complete, investigate storage integrity and consider restoring from a known-good backup; capture the details and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add high key to left page after split
```

## Related

- [failed to add high key to the index page](./failed-to-add-high-key-to-the-index-page.md)
- [failed to add high key to the left sibling while splitting block of index](./failed-to-add-high-key-to-the-left-sibling-while-splitting-block-of-index.md)
