---
message: "attempted to update invisible tuple"
slug: attempted-to-update-invisible-tuple
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:3439"
reproduced: false
---

# `attempted to update invisible tuple`

## What it means

The executor tried to update a heap tuple that was not visible to the command's snapshot. Updating a row that the current command cannot see is a violation of the storage manager's invariants, so the operation is rejected.

## When it happens

It surfaces from the heap update path, usually behind an unusual combination of triggers, writable CTEs, or an extension that reaches into low-level tuple routines. In normal SQL it does not occur.

## How to fix

This is an internal consistency check rather than a user-facing condition. If a plain statement raised it, treat it as a possible bug or as heap corruption: capture the statement, note any triggers or extensions in play, run `amcheck` and heap checks, and report it with a reproducer if you can build one.

## Example

*Illustrative* — the guard firing during an update.

```text
ERROR:  attempted to update invisible tuple
```

## Related

- [block of is still referenced](./block-of-is-still-referenced-local.md)
- [bogus pg_index tuple](./bogus-pg-index-tuple.md)
