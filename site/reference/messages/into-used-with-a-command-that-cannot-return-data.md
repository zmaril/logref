---
message: "INTO used with a command that cannot return data"
slug: into-used-with-a-command-that-cannot-return-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4462"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4652"
reproduced: false
---

# `INTO used with a command that cannot return data`

## What it means

A PL/pgSQL statement used the `INTO` clause with a command that produces no rows, so there is nothing to store into the target variables.

## When it happens

It happens in PL/pgSQL when `INTO` is attached to a statement that cannot return data — for example `EXECUTE 'UPDATE ...' INTO x` without a `RETURNING` clause, or `INTO` on a utility command such as `SET` or `CREATE`.

## How to fix

Only use `INTO` with statements that return rows: a `SELECT`, or an `INSERT`/`UPDATE`/`DELETE` that has a `RETURNING` clause. Add `RETURNING` to the data-modifying command, or drop the `INTO` clause if you do not need a result.

## Example

*Illustrative* — capturing output from a command that returns none.

```sql
EXECUTE 'UPDATE t SET x = 1' INTO v;  -- add RETURNING, or drop INTO
```

## Related

- [non-SELECT statement in DECLARE CURSOR](./non-select-statement-in-declare-cursor.md)
- [only WITH CHECK expression allowed for INSERT](./only-with-check-expression-allowed-for-insert.md)
