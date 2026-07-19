---
message: "aggregates cannot return sets"
slug: aggregates-cannot-return-sets
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:816"
reproduced: false
---

# `aggregates cannot return sets`

## What it means

A `CREATE AGGREGATE` named a final function whose return type is a set (set-returning), but an aggregate must produce exactly one value per group.

## When it happens

It occurs when the aggregate's final function is set-returning, which is not permitted for aggregates.

## How to fix

Use a final function that returns a single value. If you need multiple output rows, model the computation as a set-returning function called separately, not as an aggregate's final function.

## Example

*Illustrative* — an aggregate whose final function returns a set.

```text
ERROR:  aggregates cannot return sets
```

## Related

- [aggregates cannot accept set arguments](./aggregates-cannot-accept-set-arguments.md)
- [aggregate function calls cannot contain set-returning function calls](./aggregate-function-calls-cannot-contain-set-returning-function-calls.md)
