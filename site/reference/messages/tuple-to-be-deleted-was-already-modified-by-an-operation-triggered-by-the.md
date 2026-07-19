---
message: "tuple to be deleted was already modified by an operation triggered by the current command"
slug: tuple-to-be-deleted-was-already-modified-by-an-operation-triggered-by-the
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_DATA_CHANGE_VIOLATION
    code: "27000"
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:1959"
  - "postgres/src/backend/executor/nodeModifyTable.c:2033"
reproduced: false
---

# `tuple to be deleted was already modified by an operation triggered by the current command`

## What it means

During a command, a trigger (or a nested action fired by the current command) modified the very row the command was about to delete, so the delete now sees a row changed underneath it. Postgres refuses to proceed to avoid acting on stale row state.

## When it happens

It arises when a `BEFORE` trigger, or a data-modifying action triggered by the current statement, updates or deletes the same target row that the outer command is deleting — a self-interfering trigger design.

## How to fix

Revise the trigger logic so it does not modify the row that the triggering command is already deleting. Move the conflicting change out of the same command, or restructure the triggers so they do not act on the in-flight target row.

## Example

*Illustrative* — a trigger modifying the row being deleted.

```text
ERROR:  tuple to be deleted was already modified by an operation triggered by the current command
```

## Related

- [tuple to be updated or deleted was already modified by an operation triggered by the current command](./tuple-to-be-updated-or-deleted-was-already-modified-by-an-operation-triggered.md)
- [source row not found](./source-row-not-found.md)
