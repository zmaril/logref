---
message: "JSON path expression in JSON_VALUE must return single scalar item"
slug: json-path-expression-in-json-value-must-return-single-scalar-item
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_MORE_THAN_ONE_SQL_JSON_ITEM
    code: "22034"
  - symbol: ERRCODE_SQL_JSON_SCALAR_REQUIRED
    code: "2203F"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4366"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4390"
reproduced: false
---

# `JSON path expression in JSON_VALUE must return single scalar item`

## What it means

`JSON_VALUE` requires its path to return exactly one scalar, but the path matched multiple items or a non-scalar (an array or object). `JSON_VALUE` yields a single scalar; use `JSON_QUERY` for structured results.

## When it happens

It arises from `JSON_VALUE(js, path)` when the path points at an array or object, or matches several items, rather than a lone scalar.

## How to fix

Adjust the path to select a single scalar value, or switch to `JSON_QUERY` when you want an object or array back. `JSON_VALUE` is for extracting one scalar; `JSON_QUERY` returns JSON.

## Example

*Illustrative* — JSON_VALUE over a path that returns an object.

```sql
SELECT JSON_VALUE('{"a":{"b":1}}', '$.a');  -- $.a is an object; use JSON_QUERY
```

## Related

- [JSON path expression for column must return single scalar item](./json-path-expression-for-column-must-return-single-scalar-item.md)
- [jsonpath item method can only be applied to a string](./jsonpath-item-method-can-only-be-applied-to-a-string.md)
