---
message: "unrecognized table_tuple_lock status: %u"
slug: unrecognized-table-tuple-lock-status
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:3487"
  - "postgres/src/backend/executor/nodeLockRows.c:246"
  - "postgres/src/backend/executor/nodeModifyTable.c:3121"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3339"
reproduced: false
---

# `unrecognized table_tuple_lock status: %u`

## What it means

Internal error. After asking the table access method to lock a tuple, code received a status code it does not recognize. The placeholder is the status value. The lock attempt should return one of a fixed set of outcomes, so an unrecognized one is a consistency check in the row-locking path.

## When it happens

It does not arise from ordinary SQL. It points to a bug in a table access method or in the row-locking caller, rather than to anything in your data or query.

## How to fix

Treat it as an internal bug. If a non-default table access method (an extension) is in use, suspect it and confirm it matches the server version. Capture the operation and report it.

## Example

*Illustrative* — emitted internally after a tuple-lock attempt.

```text
ERROR:  unrecognized table_tuple_lock status: 99
```

## Related

- [unrecognized lock mode](./unrecognized-lock-mode.md)
- [failed to fetch tuple being updated](./failed-to-fetch-tuple-being-updated.md)
