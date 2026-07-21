---
message: "cache lookup failed for not-null constraint on column \"%s\" of relation %u"
slug: cache-lookup-failed-for-not-null-constraint-on-column-of-relation-117101
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13196"
  - "postgres/src/backend/commands/tablecmds.c:14796"
reproduced: false
---

# `cache lookup failed for not-null constraint on column "%s" of relation %u`

## What it means

Internal error. The not-null constraint catalog row for a named column of a relation could not be found. The placeholders are the column name and the relation OID. Table-definition code expected a not-null constraint entry that was no longer present.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an inconsistency between a column's not-null marking and its `pg_constraint` row, typically during `ALTER TABLE` on a catalog left in an unexpected state.

## How to fix

Treat it as an internal inconsistency. Capture the exact `ALTER TABLE` and the table definition and report it. If a specific table reproduces it, inspect its `pg_constraint` and `pg_attribute` rows for the column; a mismatch there indicates catalog damage worth restoring from backup.

## Example

*Illustrative* — emitted while altering a column whose not-null catalog row was missing.

```text
ERROR:  cache lookup failed for not-null constraint on column "id" of relation 16711
```

## Related

- [cannot add not-null constraint on system column](./cannot-add-not-null-constraint-on-system-column.md)
- [column of relation contains null values](./column-of-relation-contains-null-values.md)
