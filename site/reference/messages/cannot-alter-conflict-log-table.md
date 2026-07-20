---
message: "cannot alter conflict log table \"%s\""
slug: cannot-alter-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6935"
  - "postgres/src/backend/commands/tablecmds.c:20327"
reproduced: false
---

# `cannot alter conflict log table "%s"`

## What it means

A command tried to alter a table that serves as a conflict log table for logical replication. The placeholder is the table name. Its structure is managed by the replication machinery and is not open to user `ALTER TABLE`.

## When it happens

Running `ALTER TABLE` against a conflict log table directly, rather than through the replication configuration that owns it.

## How to fix

Leave the conflict log table's definition to the subscription or replication feature that created it. Manage conflict logging through the relevant subscription options rather than by altering the table by hand. If you no longer need it, remove it through the owning configuration.

## Example

*Illustrative* — altering a managed conflict log table.

```text
ERROR:  cannot alter conflict log table "pg_conflict_log"
```

## Related

- [conflict log table cannot have rules](./conflict-log-table-cannot-have-rules.md)
- [cannot set parameter to false for publication](./cannot-set-parameter-to-false-for-publication.md)
