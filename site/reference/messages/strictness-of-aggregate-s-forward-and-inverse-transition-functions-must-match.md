---
message: "strictness of aggregate's forward and inverse transition functions must match"
slug: strictness-of-aggregate-s-forward-and-inverse-transition-functions-must-match
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:350"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3178"
reproduced: false
---

# `strictness of aggregate's forward and inverse transition functions must match`

## What it means

A moving-aggregate definition has a forward transition function and an inverse transition function whose strictness (whether they are declared `STRICT`) differs. For moving aggregates the two must have the same strictness so null handling stays consistent across window movement.

## When it happens

It arises from `CREATE AGGREGATE` that supplies both `sfunc`/`msfunc` and `minvfunc` where one is `STRICT` and the other is not.

## How to fix

Declare both the forward (`msfunc`) and inverse (`minvfunc`) transition functions with the same strictness — either both `STRICT` or both non-strict — and ensure they handle nulls consistently.

## Example

*Illustrative* — mismatched strictness on moving-aggregate transitions.

```text
ERROR:  strictness of aggregate's forward and inverse transition functions must match
```

## Related

- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
- [type mismatch in hypothetical-set function](./type-mismatch-in-hypothetical-set-function.md)
