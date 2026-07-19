---
message: "empty query"
slug: empty-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/intarray/_int_bool.c:694"
reproduced: false
---

# `empty query`

## What it means

The `intarray` extension's query-parsing routine was given an empty query expression. The `query_int` boolean-query type needs at least one term.

## When it happens

It fires from `intarray` query operators when the query string (a `query_int` value) is empty or contains no terms.

## How to fix

Provide a non-empty query expression, for example `'1|2'::query_int`. Check that the value you pass to the `@@` operator or `query_int` cast is not blank.

## Example

*Illustrative* — an empty intarray query.

```sql
SELECT '{1,2,3}'::int[] @@ ''::query_int;
-- empty query
```

## Related

- [empty query does not return tuples](./empty-query-does-not-return-tuples.md)
- [distance in phrase operator must be an integer value between zero and inclusive](./distance-in-phrase-operator-must-be-an-integer-value-between-zero-and-inclusive.md)
