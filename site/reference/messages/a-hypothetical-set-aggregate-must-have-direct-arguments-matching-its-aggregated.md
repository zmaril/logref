---
message: "a hypothetical-set aggregate must have direct arguments matching its aggregated arguments"
slug: a-hypothetical-set-aggregate-must-have-direct-arguments-matching-its-aggregated
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:197"
reproduced: false
---

# `a hypothetical-set aggregate must have direct arguments matching its aggregated arguments`

## What it means

A `CREATE AGGREGATE` for a hypothetical-set aggregate declared direct arguments (the hypothetical row) that do not match, in number and type, the aggregated arguments it is compared against.

## When it happens

It occurs when defining an ordered-set aggregate of the hypothetical-set kind (like `rank`/`dense_rank` as a hypothetical-set function) whose `(direct_args) ORDER BY (agg_args)` signatures are not parallel.

## How to fix

Make the direct-argument list line up one-to-one with the aggregated-argument list in count and data types. A hypothetical-set aggregate compares a supplied hypothetical row against the ordered group, so the two lists must describe the same shape of row.

## Example

*Illustrative* — mismatched direct and aggregated argument lists.

```sql
CREATE AGGREGATE my_rank(int) (... ORDER BY text ...);  -- direct (int) vs aggregated (text)
```

## Related

- [a variadic ordered-set aggregate must use VARIADIC type ANY](./a-variadic-ordered-set-aggregate-must-use-variadic-type-any.md)
- [aggregate input type must be specified](./aggregate-input-type-must-be-specified.md)
