---
message: "attempted to delete invisible tuple"
slug: attempted-to-delete-invisible-tuple
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:2797"
reproduced: false
---

# `attempted to delete invisible tuple`

## What it means

The executor tried to delete a heap tuple that its snapshot rules say is not visible to the current operation, which should never happen in correct execution — an internal consistency guard, sometimes a sign of heap corruption.

## When it happens

It is raised during a delete when the targeted tuple is not in a state the delete path expects, generally through a concurrency-handling bug, a broken index pointing at a dead tuple, or underlying corruption.

## How to fix

This is an internal error, not a query to rewrite. If it recurs on a specific table, treat the table or its indexes as possibly corrupt: reindex, check with `amcheck`, and inspect storage health. Capture the statement and log and report it, and restore from backup if corruption is confirmed.

## Example

*Illustrative* — a delete targeting an invisible tuple.

```text
ERROR:  attempted to delete invisible tuple
```

## Related

- [attempted to overwrite invisible tuple](./attempted-to-overwrite-invisible-tuple.md)
- [attempted to kill a tuple inserted by another transaction](./attempted-to-kill-a-tuple-inserted-by-another-transaction.md)
