---
message: "cannot alter temporary tables of other sessions"
slug: cannot-alter-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4550"
reproduced: false
---

# `cannot alter temporary tables of other sessions`

## What it means

A command tried to alter a temporary table that belongs to a different session. Temporary tables are private to the session that created them, so another session cannot alter them even though their catalog entries are visible.

## When it happens

It occurs when an `ALTER TABLE` or similar command names a temporary table created by another session, often reached through system-catalog inspection or automated maintenance.

## How to fix

Do not operate on other sessions' temporary tables; they are owned and managed by their creating session and are cleaned up when it ends. Perform the change from the session that created the table, or use a permanent table if the object must be shared.

## Example

*Illustrative* — altering another session's temp table.

```text
ERROR:  cannot alter temporary tables of other sessions
```

## Related

- [cannot access temporary tables during a parallel operation](./cannot-access-temporary-tables-during-a-parallel-operation.md)
- [cannot alter inherited column](./cannot-alter-inherited-column.md)
