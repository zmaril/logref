---
message: "jsonpath item method .%s() can only be applied to a string or numeric value"
slug: jsonpath-item-method-can-only-be-applied-to-a-string-or-numeric-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NON_NUMERIC_SQL_JSON_ITEM
    code: "22036"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1245"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1346"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1486"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1611"
reproduced: false
---

# `jsonpath item method .%s() can only be applied to a string or numeric value`

## What it means

A jsonpath item method was applied to a JSON value of the wrong kind. The placeholder is the method name (like `.number()`, `.double()`, `.bigint()`). These conversion methods operate on strings or numbers; applying them to an object, array, boolean, or null is invalid.

## When it happens

Evaluating a jsonpath (in `jsonb_path_query`, `JSON_VALUE`, etc.) whose item method lands on a value that is not a string or number — for example calling `.double()` on a JSON object or array element.

## How to fix

Ensure the path selects a string or numeric value before applying the method. Use a filter (`? (@.type() == "number")`) or adjust the path so the method only sees scalars. If values vary, guard with `ON ERROR` behavior in the SQL/JSON function to tolerate the mismatch.

## Example

*Illustrative* — a numeric method on a non-scalar.

```sql
SELECT jsonb_path_query('{"a":1}', '$.double()');
```

## Related

- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
- [null value not allowed for object key](./null-value-not-allowed-for-object-key.md)
