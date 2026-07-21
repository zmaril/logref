---
message: "argument of %s must not contain variables"
slug: argument-of-must-not-contain-variables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:2077"
reproduced: false
---

# `argument of %s must not contain variables`

## What it means

An expression used in a context that must be constant with respect to the surrounding query contained a column reference or other variable, which is not allowed there.

## When it happens

It occurs where a clause requires a value that does not depend on table columns — for example certain configuration-like or definition-time expressions — but a column variable was used.

## How to fix

Replace the variable with a constant or a parameter that does not reference table columns. If you need per-row behavior, use a construct that permits column references; the position that raised this requires an expression free of variables.

## Example

*Illustrative* — a column reference where a constant is required.

```text
ERROR:  argument of LIMIT must not contain variables
```

## Related

- [argument of nth_value must be greater than zero](./argument-of-nth-value-must-be-greater-than-zero.md)
- [arguments to GROUPING must be grouping expressions of the associated query level](./arguments-to-grouping-must-be-grouping-expressions-of-the-associated-query-level.md)
