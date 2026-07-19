---
message: "cannot reindex while reindexing"
slug: cannot-reindex-while-reindexing
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:4177"
  - "postgres/src/backend/catalog/index.c:4209"
reproduced: false
---

# `cannot reindex while reindexing`

## What it means

A `REINDEX` was started while the same backend is already in the middle of a reindex operation. Reindexing is not re-entrant, so nesting one reindex inside another is rejected.

## When it happens

Triggering a `REINDEX` from within code that runs during another reindex — for example an index expression, a trigger, or an event trigger that itself issues `REINDEX` while a reindex is underway.

## How to fix

Ensure no reindex is issued from within an index build or from code that runs during a reindex. Move any such `REINDEX` out of expressions, triggers, and functions invoked during index maintenance so reindexes never nest.

## Example

*Illustrative* — a nested reindex.

```text
ERROR:  cannot reindex while reindexing
```

## Related

- [cannot reindex invalid index on TOAST table](./cannot-reindex-invalid-index-on-toast-table.md)
- [cannot modify reindex state during a parallel operation](./cannot-modify-reindex-state-during-a-parallel-operation.md)
