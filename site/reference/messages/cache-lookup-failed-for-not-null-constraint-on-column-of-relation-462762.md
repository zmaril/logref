---
message: "cache lookup failed for not-null constraint on column \"%s\" of relation \"%s\""
slug: cache-lookup-failed-for-not-null-constraint-on-column-of-relation-462762
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7954"
  - "postgres/src/backend/commands/tablecmds.c:8445"
  - "postgres/src/backend/commands/tablecmds.c:13812"
reproduced: false
---

# `cache lookup failed for not-null constraint on column "%s" of relation "%s"`

## What it means

Internal error. The catalog row for a column's not-null constraint could not be found. The placeholders are the column and relation names. Since Postgres tracks not-null constraints as catalog objects, code expected the constraint entry to exist for a column that still has it.

## When it happens

A concurrent DDL change to the column's constraints, or catalog inconsistency in `pg_constraint`. Not caused by ordinary data.

## How to fix

If it coincides with concurrent `ALTER TABLE` touching the column's constraints, retry. If it recurs, inspect `pg_constraint` for the relation; a missing not-null entry for a column marked `NOT NULL` indicates corruption and warrants investigation. Report reproducible cases.

## Example

*Illustrative* — a not-null constraint row not found.

```text
ERROR:  cache lookup failed for not-null constraint on column "c" of relation "t"
```

## Related

- [cache lookup failed for constraint](./cache-lookup-failed-for-constraint.md)
- [column of relation is an identity column](./column-of-relation-is-an-identity-column.md)
