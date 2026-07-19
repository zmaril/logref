---
message: "tuple to be updated or deleted was already modified by an operation triggered by the current command"
slug: tuple-to-be-updated-or-deleted-was-already-modified-by-an-operation-triggered
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_DATA_CHANGE_VIOLATION
    code: "27000"
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:3788"
  - "postgres/src/backend/executor/nodeModifyTable.c:3985"
reproduced: false
---

# `tuple to be updated or deleted was already modified by an operation triggered by the current command`

## What it means

During a command, a trigger or a nested action fired by the current command already updated or deleted the row this command was about to update or delete. The outer operation would be acting on a row that changed underneath it, so it is refused.

## When it happens

It arises when triggers (often `BEFORE` triggers) or triggered data-modifying actions touch the same target row the statement is updating/deleting, within the same command.

## How to fix

Adjust the trigger logic so it does not modify the row the triggering statement is already changing. Separate the conflicting modification into a different command, or redesign the triggers to avoid re-touching the in-flight target row.

## Example

*Illustrative* — a trigger modifying the row being updated.

```text
ERROR:  tuple to be updated or deleted was already modified by an operation triggered by the current command
```

## Related

- [tuple to be deleted was already modified by an operation triggered by the current command](./tuple-to-be-deleted-was-already-modified-by-an-operation-triggered-by-the.md)
- [source row not found](./source-row-not-found.md)
