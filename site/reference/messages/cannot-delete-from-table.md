---
message: "cannot delete from table \"%s\""
slug: cannot-delete-from-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/executor/execReplication.c:1087"
  - "postgres/src/backend/executor/execReplication.c:1093"
  - "postgres/src/backend/executor/execReplication.c:1099"
reproduced: false
---

# `cannot delete from table "%s"`

## What it means

Logical replication apply could not delete a row in the target table because the table has no way to identify the row — it lacks a replica identity usable for the delete. The placeholder names the table. To apply a replicated `DELETE`, the subscriber needs a replica identity (a primary key or a designated unique index) to find the matching row.

## When it happens

Applying replicated deletes (or updates) to a table on the subscriber that has no primary key and no `REPLICA IDENTITY` configured, so the incoming old-row image cannot be matched.

## How to fix

Give the target table a usable replica identity: add a primary key, or set `ALTER TABLE ... REPLICA IDENTITY FULL` (or `USING INDEX <unique_index>`). The publisher's table also needs an appropriate replica identity for the old-row image to be sent. Once the table can identify rows, apply resumes.

## Example

*Illustrative* — a replicated delete with no replica identity.

```text
ERROR:  cannot delete from table "t"
```

## Related

- [cannot update table](./cannot-update-table.md)
- [subscription could not connect to the publisher](./subscription-could-not-connect-to-the-publisher.md)
