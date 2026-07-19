---
message: "attempted to update or delete invisible tuple"
slug: attempted-to-update-or-delete-invisible-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:3802"
  - "postgres/src/backend/executor/nodeModifyTable.c:3999"
reproduced: false
---

# `attempted to update or delete invisible tuple`

## What it means

Internal error. The executor tried to update or delete a row version that is not visible to the current operation. Modifications must target a live, visible tuple, and this one was not, so the operation stopped as a consistency check.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in tuple visibility or concurrency handling, or possibly heap corruption, rather than to your statement.

## How to fix

Treat it as an internal-bug or corruption signal. If it recurs on a specific table, check that table's integrity (for example with `amcheck` on its indexes and a careful review of the heap) and consider restoring affected data from a backup. Capture the statement and context and report it.

## Example

*Illustrative* — modifying an invisible row version.

```text
ERROR:  attempted to update or delete invisible tuple
```

## Related

- [tuple offset out of range](./tuple-offset-out-of-range.md)
- [tuple concurrently updated](./tuple-concurrently-updated.md)
