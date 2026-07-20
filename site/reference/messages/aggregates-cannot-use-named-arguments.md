---
message: "aggregates cannot use named arguments"
slug: aggregates-cannot-use-named-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:831"
reproduced: false
---

# `aggregates cannot use named arguments`

## What it means

An aggregate was called using named-argument notation (`name => value`), which aggregates do not support.

## When it happens

It occurs when invoking an aggregate with the `arg => value` syntax that is allowed for ordinary function calls.

## How to fix

Call the aggregate with positional arguments instead of named ones. Named-argument notation is only available for regular functions, not aggregates.

## Example

*Illustrative* — named-argument syntax on an aggregate.

```sql
SELECT my_agg(val => x) FROM t;  -- ERROR:  aggregates cannot use named arguments
```

## Related

- [aggregate functions do not accept RESPECT/IGNORE NULLS](./aggregate-functions-do-not-accept-respect-ignore-nulls.md)
- [a variadic ordered-set aggregate must use VARIADIC type ANY](./a-variadic-ordered-set-aggregate-must-use-variadic-type-any.md)
