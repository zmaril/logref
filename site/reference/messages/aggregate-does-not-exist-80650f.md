---
message: "aggregate %s(*) does not exist"
slug: aggregate-does-not-exist-80650f
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2555"
reproduced: false
---

# `aggregate %s(*) does not exist`

## What it means

A statement referred to an aggregate called with `*` (the `agg(*)` form) that does not exist with a matching signature in the search path.

## When it happens

It occurs when using the `agg(*)` syntax — chiefly `count(*)` style calls — with an aggregate name that is not defined, or in a schema not on the search path.

## How to fix

Check the aggregate name and that it supports the `(*)` form. Only certain aggregates (notably `count`) accept `*`; for others, pass the actual argument. Schema-qualify the name or fix the search path if the aggregate lives elsewhere.

## Example

*Illustrative* — a nonexistent aggregate used with (*).

```sql
SELECT tally(*) FROM t;  -- ERROR:  aggregate tally(*) does not exist
```

## Related

- [aggregate %s does not exist](./aggregate-does-not-exist-fab492.md)
- [aggregate name is not unique](./aggregate-name-is-not-unique.md)
