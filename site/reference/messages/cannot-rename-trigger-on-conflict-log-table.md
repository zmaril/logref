---
message: "cannot rename trigger on conflict log table \"%s\""
slug: cannot-rename-trigger-on-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:1465"
reproduced: false
---

# `cannot rename trigger on conflict log table "%s"`

## What it means

An `ALTER TRIGGER ... RENAME` targeted a trigger on a conflict log table. The conflict log table is system-managed, and its triggers cannot be renamed. The placeholder is the table name.

## When it happens

It occurs when you attempt to rename a trigger attached to a conflict log table.

## How to fix

Leave the conflict log table's triggers unchanged. The table and its triggers are maintained by the replication apply machinery.

## Example

*Illustrative* — renaming a trigger on a conflict log table.

```text
ERROR:  cannot rename trigger on conflict log table "pg_conflict_log"
```

## Related

- [cannot rename trigger on table](./cannot-rename-trigger-on-table.md)
- [cannot rename columns of conflict log table](./cannot-rename-columns-of-conflict-log-table.md)
