---
message: "cannot update foreign table \"%s\""
slug: cannot-update-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1157"
reproduced: false
---

# `cannot update foreign table "%s"`

## What it means

An `UPDATE` targeted a foreign table whose foreign-data wrapper does not support updates. The wrapper did not provide the routines needed to modify remote rows, so the update cannot be carried out.

## When it happens

It occurs on `UPDATE foreign_table SET ...` when the wrapper is read-only or does not implement the update path, or when a required option such as a key column is missing.

## How to fix

Use a wrapper that supports writes, and set the options it needs to identify rows. If the source is read-only, make the change at the remote side directly instead of through the foreign table.

## Example

*Illustrative* — updating a read-only foreign table.

```sql
UPDATE remote_events SET status = 'done';
-- ERROR:  cannot update foreign table "remote_events"
```

## Related

- [cannot truncate foreign table](./cannot-truncate-foreign-table.md)
- [cannot use relation as logical replication target](./cannot-use-relation-as-logical-replication-target.md)
