---
message: "tuple to be updated was already modified by an operation triggered by the current command"
slug: tuple-to-be-updated-was-already-modified-by-an-operation-triggered-by-the
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
  - symbol: ERRCODE_TRIGGERED_DATA_CHANGE_VIOLATION
    code: "27000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6390"
  - "postgres/src/backend/commands/trigger.c:3425"
  - "postgres/src/backend/executor/nodeModifyTable.c:2873"
  - "postgres/src/backend/executor/nodeModifyTable.c:2963"
reproduced: false
---

# `tuple to be updated was already modified by an operation triggered by the current command`

## What it means

During an `UPDATE`, `DELETE`, or `MERGE`, a `BEFORE` trigger (or a function it called) modified the very row the command was in the middle of updating, and the command cannot proceed on a row that changed underneath it. Postgres refuses this rather than silently applying an inconsistent change.

## When it happens

A `BEFORE ROW` trigger on the target table updates or deletes the same row that fired it (directly, or via a chain of triggers or a data-modifying function), so the row the outer command holds is no longer the version it read.

## How to fix

Rework the trigger so it does not modify the row currently being updated — a `BEFORE` trigger should adjust `NEW` and return it rather than issuing a separate `UPDATE` of the same row. Move cross-row side effects to an `AFTER` trigger, or restructure the logic so the triggering command and the trigger touch different rows.

## Example

*Illustrative* — a BEFORE trigger updating its own row.

```text
ERROR:  tuple to be updated was already modified by an operation triggered by the current command
```

## Related

- [command cannot affect row a second time](./command-cannot-affect-row-a-second-time.md)
- [failed to fetch tuple being updated](./failed-to-fetch-tuple-being-updated.md)
