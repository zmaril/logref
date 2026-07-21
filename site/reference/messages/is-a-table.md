---
message: "\"%s\" is a table"
slug: is-a-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:227"
  - "postgres/src/backend/commands/trigger.c:238"
reproduced: false
---

# `"%s" is a table`

## What it means

An operation that expected a different relation kind (such as an index, view, or sequence) was given an ordinary table. The placeholder is the object name.

## When it happens

It arises when a command that requires a non-table relation is pointed at a table — for example treating a table as an index in an index-only operation, or a command that expects a view or sequence.

## How to fix

Pass an object of the kind the command expects. Check the object type with `\d name` in psql; if you meant a related index, view, or sequence, name that object instead of the table.

## Example

*Illustrative* — using a table where an index is required.

```sql
ALTER INDEX my_table SET (fillfactor = 90);  -- my_table is a table
```

## Related

- [is a partitioned table](./is-a-partitioned-table.md)
- [is not an index for table](./is-not-an-index-for-table.md)
