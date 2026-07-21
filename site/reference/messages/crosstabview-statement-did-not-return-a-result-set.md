---
message: "\\crosstabview: statement did not return a result set"
slug: crosstabview-statement-did-not-return-a-result-set
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:127"
reproduced: false
---

# `\crosstabview: statement did not return a result set`

## What it means

The `psql` `\crosstabview` command was run on a statement that produced no result set to pivot. `\crosstabview` needs rows to work with.

## When it happens

It happens when the statement before `\crosstabview` was not a query that returns rows — for example a command such as `INSERT` without `RETURNING`, or an empty buffer.

## How to fix

Run a `SELECT` (or another row-returning statement) and then apply `\crosstabview` to it. The command pivots the rows of a result set, so the preceding statement must produce one.

## Example

*Illustrative* — no result set to pivot.

```text
\crosstabview: statement did not return a result set
```

## Related

- [\crosstabview: query must return at least three columns](./crosstabview-query-must-return-at-least-three-columns.md)
- [current transaction is aborted](./current-transaction-is-aborted.md)
