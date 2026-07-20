---
message: "a variadic ordered-set aggregate must use VARIADIC type ANY"
slug: a-variadic-ordered-set-aggregate-must-use-variadic-type-any
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:171"
reproduced: false
---

# `a variadic ordered-set aggregate must use VARIADIC type ANY`

## What it means

A `CREATE AGGREGATE` defined a variadic ordered-set aggregate but declared its variadic parameter with a concrete type, whereas ordered-set aggregates may only be variadic over `ANY`.

## When it happens

It occurs when defining an ordered-set aggregate (the `WITHIN GROUP` kind) with `VARIADIC sometype` instead of `VARIADIC "any"`.

## How to fix

Declare the variadic parameter as `VARIADIC "any"` for an ordered-set aggregate. A concrete variadic element type is not supported here; the aggregate must accept an arbitrary trailing argument list of any types.

## Example

*Illustrative* — a variadic ordered-set aggregate with a concrete type.

```sql
CREATE AGGREGATE my_pct(VARIADIC int ORDER BY float8) (...);  -- must be VARIADIC "any"
```

## Related

- [a hypothetical-set aggregate must have direct arguments matching its aggregated arguments](./a-hypothetical-set-aggregate-must-have-direct-arguments-matching-its-aggregated.md)
- [aggregates cannot use named arguments](./aggregates-cannot-use-named-arguments.md)
