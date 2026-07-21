---
message: "key value must be scalar, not array, composite, or json"
slug: key-value-must-be-scalar-not-array-composite-or-json
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:201"
  - "postgres/src/backend/utils/adt/jsonb.c:655"
reproduced: false
---

# `key value must be scalar, not array, composite, or json`

## What it means

A function that builds keyed output (such as `hstore` or a JSON-building helper) was given a key that is an array, composite, or json value. Keys must be scalar text-like values.

## When it happens

It arises when constructing key/value structures from row or record data where the column intended as the key holds a composite, array, or json value rather than a scalar.

## How to fix

Provide a scalar key — cast or extract a text/number value for the key position. If the source is composite or array, choose a scalar field from it to serve as the key.

## Example

*Illustrative* — a composite used as a key.

```text
ERROR:  key value must be scalar, not array, composite, or json
```

## Related

- [JSON path expression for column must return single scalar item](./json-path-expression-for-column-must-return-single-scalar-item.md)
- [not a jsonb array](./not-a-jsonb-array.md)
