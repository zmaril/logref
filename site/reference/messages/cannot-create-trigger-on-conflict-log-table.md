---
message: "cannot create trigger on conflict log table \"%s\""
slug: cannot-create-trigger-on-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:323"
reproduced: false
---

# `cannot create trigger on conflict log table "%s"`

## What it means

A `CREATE TRIGGER` targeted a table designated as a logical-replication conflict log table. These managed tables do not accept user triggers. The placeholder is the table name.

## When it happens

It occurs when defining a trigger on the relation serving as the conflict logging target.

## How to fix

Do not attach triggers to a conflict log table. Leave it managed by the replication configuration and place triggers on your own tables instead.

## Example

*Illustrative* — a trigger on a conflict log table.

```text
ERROR:  cannot create trigger on conflict log table "t"
```

## Related

- [cannot create policy on conflict log table](./cannot-create-policy-on-conflict-log-table.md)
- [cannot create statistics on conflict log table](./cannot-create-statistics-on-conflict-log-table.md)
