---
message: "SELECT ... INTO is not allowed here"
slug: select-into-is-not-allowed-here
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1762"
  - "postgres/src/backend/parser/analyze.c:2159"
reproduced: false
---

# `SELECT ... INTO is not allowed here`

## What it means

A `SELECT ... INTO` (the table-creating form) appeared in a context that does not allow it — for example inside a subquery, a set operation, or another place where creating a table as a side effect is not permitted.

## When it happens

It arises when `SELECT ... INTO newtable` is nested where only a plain query is allowed, or used where `CREATE TABLE AS` semantics cannot apply.

## How to fix

Use `CREATE TABLE AS SELECT ...` for creating a table from a query, at the top level of a statement. In PL/pgSQL, `SELECT ... INTO variable` is the variable-assignment form and must be used correctly; do not nest the table-creating `INTO`.

## Example

*Illustrative* — SELECT INTO nested where it is not allowed.

```text
ERROR:  SELECT ... INTO is not allowed here
```

## Related

- [row expansion via "*" is not supported here](./row-expansion-via-is-not-supported-here.md)
- [subquery must return only one column](./subquery-must-return-only-one-column.md)
