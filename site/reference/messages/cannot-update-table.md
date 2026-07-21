---
message: "cannot update table \"%s\""
slug: cannot-update-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/executor/execReplication.c:1069"
  - "postgres/src/backend/executor/execReplication.c:1075"
  - "postgres/src/backend/executor/execReplication.c:1081"
reproduced: false
---

# `cannot update table "%s"`

## What it means

Logical replication apply could not update a row in the target table because the table lacks a replica identity that lets it locate the row. The placeholder names the table. Applying a replicated `UPDATE` requires a primary key or configured replica identity to match the old-row image.

## When it happens

Applying replicated updates to a subscriber table with no primary key and no `REPLICA IDENTITY` set, so the incoming row cannot be matched to a local row.

## How to fix

Give the target table a usable replica identity: add a primary key, or `ALTER TABLE ... REPLICA IDENTITY FULL` (or `USING INDEX <unique_index>`). Ensure the publisher side sends a suitable old-row image. Once rows can be identified, apply resumes.

## Example

*Illustrative* — a replicated update with no replica identity.

```text
ERROR:  cannot update table "t"
```

## Related

- [cannot delete from table](./cannot-delete-from-table.md)
- [cannot assign to system column](./cannot-assign-to-system-column.md)
