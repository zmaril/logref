---
message: "failed to re-find tuple within index \"%s\""
slug: failed-to-re-find-tuple-within-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/access/gin/ginget.c:269"
  - "postgres/src/backend/access/nbtree/nbtinsert.c:774"
reproduced: false
---

# `failed to re-find tuple within index "%s"`

## What it means

Internal error. Maintenance code (GIN posting-tree or b-tree) could not locate a tuple it had previously found within an index. The `%s` is the index name. It is a consistency guard.

## When it happens

It fires during index maintenance when a tuple expected to still be present could not be re-found. Ordinary queries do not raise it; it can accompany index corruption or a concurrency bug.

## How to fix

Reindex the affected index. If it recurs, check storage health and capture the index name and a reproducible case for a bug report.

## Example

*Illustrative* — a tuple could not be re-found in the index.

```text
ERROR:  failed to re-find tuple within index "my_idx"
```

## Related

- [failed to add new item to the right sibling while splitting block of index](./failed-to-add-new-item-to-the-right-sibling-while-splitting-block-of-index.md)
- [failed to update partially dead item in block of index](./failed-to-update-partially-dead-item-in-block-of-index.md)
