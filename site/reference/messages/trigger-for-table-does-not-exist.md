---
message: "trigger \"%s\" for table \"%s\" does not exist"
slug: trigger-for-table-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/trigger.c:1414"
  - "postgres/src/backend/commands/trigger.c:1581"
  - "postgres/src/backend/commands/trigger.c:1862"
reproduced: false
---

# `trigger "%s" for table "%s" does not exist`

## What it means

A command referenced a trigger by name on a table that has no trigger by that name. The trigger name must belong to the named table, and it does not.

## When it happens

Running `ALTER TRIGGER`, `DROP TRIGGER`, or a `COMMENT ON TRIGGER` with a misspelled trigger name, a trigger already dropped, or a name that belongs to a different table.

## How to fix

List the table's triggers with `\d tablename` in psql and use the exact trigger name on the correct table. Confirm the trigger was not removed by an earlier migration.

## Example

*Illustrative* — dropping a trigger that does not exist.

```sql
DROP TRIGGER no_such ON orders;  -- no trigger "no_such" on orders
```

## Related

- [index for table does not exist](./index-for-table-does-not-exist.md)
- [relation cannot have triggers](./relation-cannot-have-triggers.md)
