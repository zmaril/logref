---
message: "jsonpath item method .%s() can only be applied to a string"
slug: jsonpath-item-method-can-only-be-applied-to-a-string
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_SQL_JSON_DATETIME_FUNCTION
    code: "22031"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2457"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2923"
reproduced: false
---

# `jsonpath item method .%s() can only be applied to a string`

## What it means

A jsonpath item method that requires a string operand was applied to a value that is not a string. The placeholder names the method (such as `.datetime()` or another string-only method).

## When it happens

It arises when evaluating a jsonpath expression whose method expects a string but the matched item is a number, boolean, array, or object.

## How to fix

Apply the method only to string items, or convert the value first (for example with `.string()` where available). Adjust the path so the method operates on a text value, and check the input JSON's actual types.

## Example

*Illustrative* — a string-only method on a number.

```sql
SELECT jsonb_path_query('5', '$.datetime()');  -- 5 is not a string
```

## Related

- [JSON path expression in JSON_VALUE must return single scalar item](./json-path-expression-in-json-value-must-return-single-scalar-item.md)
- [invalid jsonpath item type for split_part](./invalid-jsonpath-item-type-for-split-part.md)
