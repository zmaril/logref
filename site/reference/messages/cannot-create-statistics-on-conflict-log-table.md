---
message: "cannot create statistics on conflict log table \"%s\""
slug: cannot-create-statistics-on-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:158"
reproduced: false
---

# `cannot create statistics on conflict log table "%s"`

## What it means

A `CREATE STATISTICS` targeted a table designated as a logical-replication conflict log table. These managed tables do not accept extended statistics objects. The placeholder is the table name.

## When it happens

It occurs when defining an extended statistics object on the relation serving as the conflict logging target.

## How to fix

Do not create statistics on a conflict log table. Leave it managed by the replication configuration and collect statistics on your own tables instead.

## Example

*Illustrative* — statistics on a conflict log table.

```text
ERROR:  cannot create statistics on conflict log table "t"
```

## Related

- [cannot create policy on conflict log table](./cannot-create-policy-on-conflict-log-table.md)
- [cannot create trigger on conflict log table](./cannot-create-trigger-on-conflict-log-table.md)
