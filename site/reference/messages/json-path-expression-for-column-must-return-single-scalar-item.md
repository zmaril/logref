---
message: "JSON path expression for column \"%s\" must return single scalar item"
slug: json-path-expression-for-column-must-return-single-scalar-item
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_MORE_THAN_ONE_SQL_JSON_ITEM
    code: "22034"
  - symbol: ERRCODE_SQL_JSON_SCALAR_REQUIRED
    code: "2203F"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4361"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:4385"
reproduced: false
---

# `JSON path expression for column "%s" must return single scalar item`

## What it means

In a `JSON_TABLE` column, the path expression produced more than one item or a non-scalar item where a single scalar was required. The column definition expects one scalar value per row.

## When it happens

It arises from `JSON_TABLE(...)` columns defined to hold a scalar when the column's path matches an array, object, or multiple items instead of exactly one scalar.

## How to fix

Narrow the column path so it selects a single scalar, or define the column with `FORMAT JSON`/as a nested path if it should hold structured data. Use `WITH WRAPPER` or an ordinality/nested-columns design when the path can match several items.

## Example

*Illustrative* — a scalar column whose path matches multiple items.

```sql
JSON_TABLE(js, '$' COLUMNS (v int PATH '$.arr'))  -- arr is not a single scalar
```

## Related

- [JSON path expression in JSON_VALUE must return single scalar item](./json-path-expression-in-json-value-must-return-single-scalar-item.md)
- [key value must be scalar not array composite or json](./key-value-must-be-scalar-not-array-composite-or-json.md)
