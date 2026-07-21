---
message: "failed to update partially dead item in block %u of index \"%s\""
slug: failed-to-update-partially-dead-item-in-block-of-index
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpage.c:1207"
  - "postgres/src/backend/access/nbtree/nbtpage.c:1328"
reproduced: false
---

# `failed to update partially dead item in block %u of index "%s"`

## What it means

Internal error during b-tree page maintenance. A partially dead (half-deleted) item in a block could not be updated as expected. The `%u` is the block and the `%s` is the index. Raised as PANIC, it aborts the process.

## When it happens

It fires during b-tree page deletion/vacuum, often in WAL replay, when the page state did not match what redo expected — a sign of index or WAL corruption.

## How to fix

As a PANIC this stops the process. Suspect index/page or WAL corruption: check storage health, and restore from a good backup if recovery cannot proceed. Reindex the affected index once the cluster is stable. Capture details and report it.

## Example

*Illustrative* — a partially dead item could not be updated.

```text
PANIC:  failed to update partially dead item in block 7 of index "my_idx"
```

## Related

- [failed to re-find tuple within index](./failed-to-re-find-tuple-within-index.md)
- [failed to add new item to left page after split](./failed-to-add-new-item-to-left-page-after-split.md)
