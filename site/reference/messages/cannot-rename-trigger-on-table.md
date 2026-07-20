---
message: "cannot rename trigger \"%s\" on table \"%s\""
slug: cannot-rename-trigger-on-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/trigger.c:1553"
reproduced: false
---

# `cannot rename trigger "%s" on table "%s"`

## What it means

An `ALTER TRIGGER ... RENAME` targeted a trigger that cannot be renamed on the given table. The trigger is of a kind — for example a constraint or internally-generated trigger — whose name is managed by the system. The placeholders are the trigger and table names.

## When it happens

It occurs when you rename an internal or constraint-backed trigger rather than a user-created one.

## How to fix

Rename only user-created triggers. For constraint triggers, manage the constraint instead; internally-generated triggers are not meant to be renamed.

## Example

*Illustrative* — renaming an internal trigger.

```text
ERROR:  cannot rename trigger "RI_ConstraintTrigger_c_1" on table "orders"
```

## Related

- [cannot rename trigger on conflict log table](./cannot-rename-trigger-on-conflict-log-table.md)
- [cannot process DELETE events](./cannot-process-delete-events.md)
