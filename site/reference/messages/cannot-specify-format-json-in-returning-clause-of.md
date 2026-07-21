---
message: "cannot specify FORMAT JSON in RETURNING clause of %s()"
slug: cannot-specify-format-json-in-returning-clause-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4460"
reproduced: false
---

# `cannot specify FORMAT JSON in RETURNING clause of %s()`

## What it means

A JSON-producing function was given a `RETURNING ... FORMAT JSON` clause where that format is not allowed. The named function already returns JSON, so the extra `FORMAT JSON` in its `RETURNING` clause is rejected.

## When it happens

It occurs when writing a `RETURNING type FORMAT JSON` clause on a function such as `json_object()` or `json_array()` where the output type does not accept a format specifier.

## How to fix

Remove `FORMAT JSON` from the `RETURNING` clause, or return a text or bytea type if you need an explicit format. Keep the `RETURNING` clause to the plain target type.

## Example

*Illustrative* — FORMAT JSON in a RETURNING clause.

```sql
SELECT json_object('a': 1 RETURNING json FORMAT JSON);
-- ERROR:  cannot specify FORMAT JSON in RETURNING clause of json_object()
```

## Related

- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
- [cannot use JSON FORMAT ENCODING clause for non-bytea input types](./cannot-use-json-format-encoding-clause-for-non-bytea-input-types.md)
