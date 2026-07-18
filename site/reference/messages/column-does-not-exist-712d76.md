---
message: "column \"%s\" does not exist"
slug: column-does-not-exist-712d76
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/commands/copy.c:1126"
  - "postgres/src/backend/commands/indexcmds.c:1980"
  - "postgres/src/backend/commands/statscmds.c:275"
  - "postgres/src/backend/commands/tablecmds.c:2669"
  - "postgres/src/backend/commands/tablecmds.c:3188"
  - "postgres/src/backend/commands/tablecmds.c:4030"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2829"
reproduced: false
---

# `column "%s" does not exist`

## What it means

A statement referenced a column name that is not present on any table in scope. The placeholder is the name as written. The table resolved fine — the column did not.

## When it happens

A misspelled column, a column that was dropped or renamed, referencing a column from a table not in the `FROM` clause, or forgetting a table alias in a multi-table query so the name is unqualified and unresolvable. In `CREATE INDEX`, `COPY`, or `ALTER TABLE` it means the named column is not on the target table.

## How to fix

List the table's columns to confirm the name and spelling: `\d schema.table` in `psql`. Qualify the column with its table or alias (`c.amount`) when several tables are joined. If a HINT accompanies the error, it often suggests the closest existing column name. Watch for quoting: a column created as `"userId"` is not the same as `userid`.

## Example

*Illustrative* — selecting a column that is not on the table (`05_catalog.sql`).

```sql
CREATE TABLE t (id int);
SELECT nope FROM t;
```

Produces:

```text
ERROR:  column "nope" does not exist
```

## Related

- [relation "%s" does not exist](./relation-does-not-exist-d06d8d.md)
- [column must appear in the GROUP BY clause](./column-must-appear-in-the-group-by-clause-or-be-used-in-an-aggregate-function.md)
