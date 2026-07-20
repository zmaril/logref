---
message: "cannot set JSON encoding for non-bytea output types"
slug: cannot-set-json-encoding-for-non-bytea-output-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:3526"
reproduced: false
---

# `cannot set JSON encoding for non-bytea output types`

## What it means

A JSON constructor specified an `ENCODING` clause while returning a non-`bytea` type. The JSON encoding option applies only when the output is `bytea`, so it is rejected for text or other output types.

## When it happens

It occurs when a `JSON`/`JSON_SCALAR`/`JSON_SERIALIZE` expression includes `ENCODING utf8` (or similar) but the `RETURNING` type is not `bytea`.

## How to fix

Drop the `ENCODING` clause for text output, or set the `RETURNING` type to `bytea` when you need a specific byte encoding. Encoding is meaningful only for binary output.

## Example

*Illustrative* — ENCODING with a non-bytea return type.

```text
ERROR:  cannot set JSON encoding for non-bytea output types
```

## Related

- [cannot extract elements from a scalar](./cannot-extract-elements-from-a-scalar.md)
- [cannot set a subfield to DEFAULT](./cannot-set-a-subfield-to-default.md)
