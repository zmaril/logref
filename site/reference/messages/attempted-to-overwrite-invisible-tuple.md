---
message: "attempted to overwrite invisible tuple"
slug: attempted-to-overwrite-invisible-tuple
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6378"
reproduced: false
---

# `attempted to overwrite invisible tuple`

## What it means

The executor tried to update in place a heap tuple that its snapshot rules say is not visible to the current operation, which should never happen in correct execution — an internal consistency guard, sometimes a sign of heap corruption.

## When it happens

It is raised during an update when the targeted tuple is not in the state the update path expects, generally through a concurrency-handling bug, a broken index, or underlying corruption.

## How to fix

This is an internal error, not a query to rewrite. If it recurs on a specific table, treat the table or its indexes as possibly corrupt: reindex, run `amcheck`, and check storage. Capture the statement and log and report it, and restore from backup if corruption is confirmed.

## Example

*Illustrative* — an update overwriting an invisible tuple.

```text
ERROR:  attempted to overwrite invisible tuple
```

## Related

- [attempted to delete invisible tuple](./attempted-to-delete-invisible-tuple.md)
- [attempted to kill a non-speculative tuple](./attempted-to-kill-a-non-speculative-tuple.md)
