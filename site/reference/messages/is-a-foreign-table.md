---
message: "\"%s\" is a foreign table"
slug: is-a-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:292"
  - "postgres/src/backend/commands/trigger.c:304"
  - "postgres/src/backend/commands/trigger.c:451"
reproduced: false
---

# `"%s" is a foreign table`

## What it means

A command that only applies to ordinary tables was pointed at a foreign table. Foreign tables reference data in an external server and do not support every operation a local table does, so the command was rejected.

## When it happens

Running an operation that a foreign table cannot support — for example creating certain triggers or storage-specific commands — against a name that resolves to a foreign table rather than a local one.

## How to fix

Check whether the operation is supported on foreign tables; many are not. If you meant a local table, verify the name and schema. If you need the behavior on external data, apply it on the remote side through the foreign server instead.

## Example

*Illustrative* — an operation not supported on a foreign table.

```sql
CREATE TRIGGER t BEFORE INSERT ON my_foreign_tbl ...;  -- "my_foreign_tbl" is a foreign table
```

## Related

- [is not a foreign table](./is-not-a-foreign-table.md)
- [is a view](./is-a-view.md)
