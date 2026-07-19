---
message: "cannot use JSON format with non-string output types"
slug: cannot-use-json-format-with-non-string-output-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:3513"
reproduced: false
---

# `cannot use JSON format with non-string output types`

## What it means

A JSON function was asked to return `FORMAT JSON` output as a type that is not a string type. The JSON format produces character data, so it can only be delivered as a text-like or JSON output type.

## When it happens

It occurs when a `RETURNING type FORMAT JSON` clause names a non-string type such as `int` or `bytea` on a JSON-producing function.

## How to fix

Return a string type such as `text`, `json`, or `jsonb`, or drop `FORMAT JSON` and let the function return its natural type.

## Example

*Illustrative* — FORMAT JSON to a numeric type.

```text
ERROR:  cannot use JSON format with non-string output types
```

## Related

- [cannot use JSON FORMAT ENCODING clause for non-bytea input types](./cannot-use-json-format-encoding-clause-for-non-bytea-input-types.md)
- [cannot specify FORMAT JSON in RETURNING clause of](./cannot-specify-format-json-in-returning-clause-of.md)
