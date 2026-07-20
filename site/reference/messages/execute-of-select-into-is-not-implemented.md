---
message: "EXECUTE of SELECT ... INTO is not implemented"
slug: execute-of-select-into-is-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4615"
reproduced: false
---

# `EXECUTE of SELECT ... INTO is not implemented`

## What it means

A PL/pgSQL `EXECUTE` ran a dynamic command that used `SELECT ... INTO` in the SQL sense (creating a table from a query). PL/pgSQL reserves `INTO` for capturing results into variables, so this form is not supported inside dynamic `EXECUTE`.

## When it happens

It fires from PL/pgSQL when the string passed to `EXECUTE` is a `SELECT ... INTO newtable ...` command that materializes a new table.

## How to fix

Use `CREATE TABLE newtable AS SELECT ...` instead of `SELECT ... INTO newtable`, which works fine inside dynamic `EXECUTE`. If you meant to capture query results into PL/pgSQL variables, use the statement-level `EXECUTE ... INTO var` clause rather than embedding `INTO` in the command string.

## Example

*Illustrative* — rewrite SELECT INTO as CREATE TABLE AS.

```sql
EXECUTE 'CREATE TABLE snap AS SELECT * FROM src';
```

## Related

- [EXECUTE of transaction commands is not implemented](./execute-of-transaction-commands-is-not-implemented.md)
- [EXECUTE does not support variable-result cached plans](./execute-does-not-support-variable-result-cached-plans.md)
