---
message: "relation \"%s\" cannot have triggers"
slug: relation-cannot-have-triggers
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:311"
  - "postgres/src/backend/commands/trigger.c:1342"
  - "postgres/src/backend/commands/trigger.c:1449"
reproduced: false
---

# `relation "%s" cannot have triggers`

## What it means

A trigger was requested on a relation whose kind does not support triggers. Only certain relation kinds can carry triggers, and the target is one that cannot.

## When it happens

Running `CREATE TRIGGER` against a relation kind that does not accept triggers — for example certain system or special relations — rather than a plain table, a partitioned table, a view with `INSTEAD OF`, or a foreign table where supported.

## How to fix

Confirm the target is a relation kind that supports triggers. If you meant a table, check the name and schema. If the behavior belongs on a view, use an `INSTEAD OF` trigger; if it belongs on partitioned data, attach the trigger to the partitioned table.

## Example

*Illustrative* — a trigger on an unsupported relation kind.

```sql
CREATE TRIGGER t BEFORE INSERT ON some_special_rel ...;  -- cannot have triggers
```

## Related

- [is a view](./is-a-view.md)
- [trigger for table does not exist](./trigger-for-table-does-not-exist.md)
