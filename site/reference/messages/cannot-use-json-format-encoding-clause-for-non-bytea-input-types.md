---
message: "cannot use JSON FORMAT ENCODING clause for non-bytea input types"
slug: cannot-use-json-format-encoding-clause-for-non-bytea-input-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4220"
reproduced: false
---

# `cannot use JSON FORMAT ENCODING clause for non-bytea input types`

## What it means

A JSON expression attached a `FORMAT JSON ENCODING ...` clause to an input that is not `bytea`. The encoding clause selects how raw bytes are decoded, so it only makes sense for `bytea` input.

## When it happens

It occurs in JSON constructor or query functions when a `FORMAT JSON ENCODING UTF8` (or similar) clause is applied to a `text` or other non-`bytea` argument.

## How to fix

Drop the `ENCODING` clause for text and other non-byte inputs, or cast the input to `bytea` first if it truly holds encoded bytes that need decoding.

## Example

*Illustrative* — encoding clause on text input.

```text
ERROR:  cannot use JSON FORMAT ENCODING clause for non-bytea input types
```

## Related

- [cannot use non-string types with implicit FORMAT JSON clause](./cannot-use-non-string-types-with-implicit-format-json-clause.md)
- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
