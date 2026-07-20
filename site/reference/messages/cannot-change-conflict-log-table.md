---
message: "cannot change conflict log table \"%s\""
slug: cannot-change-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20280"
reproduced: false
---

# `cannot change conflict log table "%s"`

## What it means

An operation tried to modify a table that is designated as a logical-replication conflict log table in a way that is not allowed. Conflict log tables have a fixed role, so certain changes to them are rejected. The placeholder is the table name.

## When it happens

It occurs when altering or repurposing a relation that is currently serving as the conflict logging target for logical replication.

## How to fix

Leave the conflict log table's structure managed by the replication configuration. Reconfigure conflict logging through the appropriate subscription settings rather than altering the table directly.

## Example

*Illustrative* — altering a conflict log table.

```text
ERROR:  cannot change conflict log table "t"
```

## Related

- [cannot change materialized view](./cannot-change-materialized-view.md)
- [cannot change relation](./cannot-change-relation.md)
