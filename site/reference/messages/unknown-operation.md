---
message: "unknown operation"
slug: unknown-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:4482"
  - "postgres/src/backend/executor/nodeModifyTable.c:4526"
  - "postgres/src/backend/executor/nodeModifyTable.c:5029"
reproduced: false
---

# `unknown operation`

## What it means

Internal error. Table-modification code reached a branch for a modify operation it does not recognize. The set of modify operations — insert, update, delete, and merge actions — is fixed, and the value did not match any of them. It is a consistency check on the executor.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in the executor's modify-table handling, not to your statement.

## How to fix

Treat it as an internal bug. Capture the statement and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — emitted internally by the modify-table executor.

```text
ERROR:  unknown operation
```

## Related

- [unrecognized cmd type](./unrecognized-cmd-type.md)
- [unrecognized alter table type](./unrecognized-alter-table-type.md)
