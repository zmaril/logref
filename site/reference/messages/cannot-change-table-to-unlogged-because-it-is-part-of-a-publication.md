---
message: "cannot change table \"%s\" to unlogged because it is part of a publication"
slug: cannot-change-table-to-unlogged-because-it-is-part-of-a-publication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19563"
reproduced: false
---

# `cannot change table "%s" to unlogged because it is part of a publication`

## What it means

An `ALTER TABLE ... SET UNLOGGED` targeted a table that belongs to a logical-replication publication. Unlogged tables produce no write-ahead log, which logical replication depends on, so a published table cannot be made unlogged. The placeholder is the table name.

## When it happens

It occurs when trying to make a published table unlogged while it is still part of a publication.

## How to fix

Remove the table from all publications first, then set it unlogged, if it truly does not need to be replicated. Otherwise keep it logged, since logical replication requires WAL for the table.

## Example

*Illustrative* — unlogging a published table.

```text
ERROR:  cannot change table "t" to unlogged because it is part of a publication
```

## Related

- [cannot change logged status of table because it is temporary](./cannot-change-logged-status-of-table-because-it-is-temporary.md)
- [cannot attach table as partition because it is referenced in publication except](./cannot-attach-table-as-partition-because-it-is-referenced-in-publication-except.md)
