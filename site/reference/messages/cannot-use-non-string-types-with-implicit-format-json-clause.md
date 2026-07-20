---
message: "cannot use non-string types with implicit FORMAT JSON clause"
slug: cannot-use-non-string-types-with-implicit-format-json-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:3423"
reproduced: false
---

# `cannot use non-string types with implicit FORMAT JSON clause`

## What it means

A JSON expression relied on an implicit `FORMAT JSON` reading of an input that is not a string type. The implicit form treats input as JSON text, so a non-string input such as an integer cannot be read that way.

## When it happens

It occurs in JSON query or constructor functions where an argument that is not text, `json`, `jsonb`, or `bytea` is used where JSON-formatted input is implied.

## How to fix

Pass a string-typed value, or cast the input to `text`/`json` before the JSON function. Make the format explicit only where the input type supports it.

## Example

*Illustrative* — an integer with implicit FORMAT JSON.

```text
ERROR:  cannot use non-string types with implicit FORMAT JSON clause
```

## Related

- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
- [cannot use JSON FORMAT ENCODING clause for non-bytea input types](./cannot-use-json-format-encoding-clause-for-non-bytea-input-types.md)
