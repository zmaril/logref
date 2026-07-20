---
message: "cannot truncate foreign table \"%s\""
slug: cannot-truncate-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2451"
reproduced: false
---

# `cannot truncate foreign table "%s"`

## What it means

A `TRUNCATE` named a foreign table. Truncation is a local storage operation, and a foreign table has no local storage to empty, so it cannot be truncated unless its wrapper supports the operation and it is targeted correctly.

## When it happens

It occurs on `TRUNCATE foreign_table` when the foreign-data wrapper does not implement truncation, or when a foreign table is swept in by `TRUNCATE` on a set of relations.

## How to fix

Delete rows through the wrapper with `DELETE FROM foreign_table` instead, or remove the foreign table from the `TRUNCATE` list. Use a wrapper that supports truncation if you need that behavior.

## Example

*Illustrative* — truncating a foreign table.

```sql
TRUNCATE remote_events;
-- ERROR:  cannot truncate foreign table "remote_events"
```

## Related

- [cannot update foreign table](./cannot-update-foreign-table.md)
- [cannot truncate a table referenced in a foreign key constraint](./cannot-truncate-a-table-referenced-in-a-foreign-key-constraint.md)
