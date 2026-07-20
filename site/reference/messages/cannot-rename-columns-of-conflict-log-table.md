---
message: "cannot rename columns of conflict log table \"%s\""
slug: cannot-rename-columns-of-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3917"
reproduced: false
---

# `cannot rename columns of conflict log table "%s"`

## What it means

An `ALTER TABLE ... RENAME COLUMN` targeted a conflict log table. The conflict log table is system-managed for logical-replication conflict records, and its columns cannot be renamed. The placeholder is the table name.

## When it happens

It occurs when you attempt to rename a column on a conflict log table.

## How to fix

Leave the conflict log table's structure unchanged. It is maintained by the replication apply machinery and is not meant to be altered by users.

## Example

*Illustrative* — renaming a conflict log table column.

```text
ERROR:  cannot rename columns of conflict log table "pg_conflict_log"
```

## Related

- [cannot rename columns of relation](./cannot-rename-columns-of-relation.md)
- [cannot rename trigger on conflict log table](./cannot-rename-trigger-on-conflict-log-table.md)
