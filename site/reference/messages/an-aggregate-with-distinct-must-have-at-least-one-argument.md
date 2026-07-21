---
message: "an aggregate with DISTINCT must have at least one argument"
slug: an-aggregate-with-distinct-must-have-at-least-one-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3255"
reproduced: false
---

# `an aggregate with DISTINCT must have at least one argument`

## What it means

An aggregate was written with `DISTINCT` but no arguments (the `agg(DISTINCT)` form with an empty list), and `DISTINCT` needs at least one argument to deduplicate on.

## When it happens

It occurs when combining `DISTINCT` with an argument-less aggregate call, such as attempting `count(DISTINCT *)`.

## How to fix

Provide the expression to deduplicate on, for example `count(DISTINCT col)`. `DISTINCT` cannot be applied to the argument-less `agg(*)` form; use a specific column or expression.

## Example

*Illustrative* — DISTINCT with no aggregate argument.

```sql
SELECT count(DISTINCT *) FROM t;  -- ERROR
```

## Related

- [aggregates cannot use named arguments](./aggregates-cannot-use-named-arguments.md)
- [aggregate functions do not accept RESPECT/IGNORE NULLS](./aggregate-functions-do-not-accept-respect-ignore-nulls.md)
