---
message: "constraint \"%s\" of relation \"%s\" does not exist"
slug: constraint-of-relation-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12391"
  - "postgres/src/backend/commands/tablecmds.c:12943"
  - "postgres/src/backend/commands/tablecmds.c:13474"
  - "postgres/src/backend/commands/tablecmds.c:14592"
  - "postgres/src/backend/commands/tablecmds.c:14821"
reproduced: true
---

# `constraint "%s" of relation "%s" does not exist`

## What it means

A command named a constraint that does not exist on the given table. The placeholders are the constraint name and the relation name. Constraints belong to a specific table; referring to one that was never created, was dropped, or is spelled wrong produces this.

## When it happens

Running `ALTER TABLE ... DROP CONSTRAINT`, `VALIDATE CONSTRAINT`, `ALTER CONSTRAINT`, or `RENAME CONSTRAINT` with a name that is not present on the target table.

## How to fix

List the table's constraints with `\d tablename` in psql or `SELECT conname FROM pg_constraint WHERE conrelid = 'tablename'::regclass`. Correct the name, or use `DROP CONSTRAINT IF EXISTS` when a missing constraint should be tolerated.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at DROP CONSTRAINT nonexistent_con;
```

Produces:

```text
ERROR:  constraint "nonexistent_con" of relation "at" does not exist
```

## Related

- [cannot attach index as a partition of index](./cannot-attach-index-as-a-partition-of-index.md)
- [record has no field](./record-has-no-field.md)
