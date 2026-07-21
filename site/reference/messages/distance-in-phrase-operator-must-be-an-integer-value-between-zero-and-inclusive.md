---
message: "distance in phrase operator must be an integer value between zero and %d inclusive"
slug: distance-in-phrase-operator-must-be-an-integer-value-between-zero-and-inclusive
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/tsquery_op.c:123"
reproduced: false
---

# `distance in phrase operator must be an integer value between zero and %d inclusive`

## What it means

A `tsquery` phrase operator (`<N>`) was given a distance outside the allowed range. The placeholder is the maximum. Phrase distance must be a non-negative integer up to that limit.

## When it happens

It fires when parsing or constructing a `tsquery` whose `<N>` phrase distance is negative or larger than the maximum the type permits.

## How to fix

Use a distance between 0 and the stated maximum. `<1>` (equivalent to `<->`) means adjacent lexemes; larger numbers allow more words in between. Reduce the distance if it exceeds the limit.

## Example

*Illustrative* — an out-of-range phrase distance.

```sql
SELECT to_tsquery('a <100000> b');
-- distance in phrase operator must be an integer value between zero and 16384 inclusive
```

## Related

- [empty query](./empty-query.md)
- [empty XPath expression](./empty-xpath-expression.md)
