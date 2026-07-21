---
message: "cannot get array length of a non-array"
slug: cannot-get-array-length-of-a-non-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1887"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1906"
reproduced: false
---

# `cannot get array length of a non-array`

## What it means

`json_array_length()` / `jsonb_array_length()` was called on a JSON value that is an object or another non-array, non-scalar shape. Array length is only defined for JSON arrays.

## When it happens

Calling the array-length function on a column or expression whose JSON value is an object rather than an array — often because the JSON structure varies across rows.

## How to fix

Guard the call with `jsonb_typeof(val) = 'array'`, or restructure the query so only array values reach the function. Confirm the input shape before asking for its length.

## Example

*Illustrative* — array-length on an object.

```sql
SELECT jsonb_array_length('{"a":1}');
-- ERROR:  cannot get array length of a non-array
```

## Related

- [cannot get array length of a scalar](./cannot-get-array-length-of-a-scalar.md)
- [cannot call on a non-array](./cannot-call-on-a-non-array.md)
