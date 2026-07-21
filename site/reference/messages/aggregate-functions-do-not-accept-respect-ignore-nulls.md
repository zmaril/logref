---
message: "aggregate functions do not accept RESPECT/IGNORE NULLS"
slug: aggregate-functions-do-not-accept-respect-ignore-nulls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:532"
reproduced: true
---

# `aggregate functions do not accept RESPECT/IGNORE NULLS`

## What it means

A `RESPECT NULLS` or `IGNORE NULLS` clause was attached to a plain aggregate, but that clause is only meaningful for the window functions that support it, not for aggregates.

## When it happens

It occurs when `IGNORE NULLS`/`RESPECT NULLS` is written after an ordinary aggregate call rather than after a window function like `lead`, `lag`, `first_value`, or `last_value`.

## How to fix

Remove the null-treatment clause from the aggregate. If you need null handling, apply it to a window function that accepts it, or filter nulls with a `FILTER (WHERE ...)` clause on the aggregate instead.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
SELECT count(id) IGNORE NULLS FROM repro.parent;
```

Produces:

```text
ERROR:  aggregate functions do not accept RESPECT/IGNORE NULLS
```

## Related

- [aggregate function does not support use as a window function](./aggregate-function-does-not-support-use-as-a-window-function.md)
- [aggregates cannot use named arguments](./aggregates-cannot-use-named-arguments.md)
