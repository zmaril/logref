---
message: "cannot get array length of a scalar"
slug: cannot-get-array-length-of-a-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1883"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1920"
reproduced: true
---

# `cannot get array length of a scalar`

## What it means

`json_array_length()` / `jsonb_array_length()` was called on a JSON scalar — a string, number, boolean, or null. Array length is only defined for JSON arrays, not scalars.

## When it happens

Passing a scalar JSON value to the array-length function, commonly when a field expected to hold an array actually holds a single scalar value.

## How to fix

Check the JSON type with `jsonb_typeof(val) = 'array'` before calling the function, and handle scalars separately. Ensure the data path only feeds arrays to array-length.

## Example

*Reproduced* — captured from `reproducers/scenarios/19_json_sqljson.sql`.

```sql
SELECT jsonb_array_length('5');
```

Produces:

```text
ERROR:  cannot get array length of a scalar
```

## Related

- [cannot get array length of a non-array](./cannot-get-array-length-of-a-non-array.md)
- [cannot set path in scalar](./cannot-set-path-in-scalar.md)
