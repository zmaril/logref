---
message: "constraint \"%s\" for table \"%s\" does not exist"
slug: constraint-for-table-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1234"
  - "postgres/src/backend/catalog/pg_constraint.c:1327"
reproduced: true
---

# `constraint "%s" for table "%s" does not exist`

## What it means

A command named a constraint on a table that has no constraint by that name. The placeholders are the constraint and the table. The name may not exist, may be misspelled, or may belong to a different table.

## When it happens

`ALTER TABLE ... DROP CONSTRAINT`, `VALIDATE CONSTRAINT`, or a similar command referencing a constraint name that is wrong, already dropped, or defined on another table.

## How to fix

List the table's constraints with `\d tablename` in psql (or query `pg_constraint`) and use the exact name. Confirm the constraint was not already removed by an earlier migration, and use `IF EXISTS` where you want the drop to be tolerant.

## Example

*Reproduced* — captured from `reproducers/scenarios/28_typecmds_domain_comment.sql`.

```sql
COMMENT ON CONSTRAINT nope ON repro.parent IS 'x';
```

Produces:

```text
ERROR:  constraint "nope" for table "parent" does not exist
```

## Related

- [constraint of domain does not exist](./constraint-of-domain-does-not-exist.md)
- [constraint declared INITIALLY DEFERRED must be DEFERRABLE](./constraint-declared-initially-deferred-must-be-deferrable.md)
