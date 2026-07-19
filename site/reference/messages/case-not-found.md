---
message: "case not found"
slug: case-not-found
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CASE_NOT_FOUND
    code: "20000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2658"
reproduced: false
---

# `case not found`

## What it means

A `CASE` expression with no `ELSE` branch was evaluated and none of its `WHEN` conditions matched. Without an `ELSE`, an unmatched `CASE` has no value to return, so it raises this error at run time.

## When it happens

It occurs at execution when a searched or simple `CASE` reaches a row whose value satisfies none of the listed conditions and no `ELSE` clause was written. It is most common inside PL/pgSQL `CASE` statements.

## How to fix

Add an `ELSE` branch to cover the remaining cases, even if it just returns `NULL` or raises a clearer error. Confirm the `WHEN` conditions cover every value you expect.

## Example

*Illustrative* — an unmatched CASE without ELSE.

```sql
SELECT CASE WHEN false THEN 1 END WHERE ...;
-- ERROR:  case not found
```

## Related

- [case insensitive matching not supported on type bytea](./case-insensitive-matching-not-supported-on-type-bytea.md)
- [column filter expression must not be null](./column-filter-expression-must-not-be-null.md)
