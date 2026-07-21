---
message: "cannot call %s on a non-array"
slug: cannot-call-on-a-non-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2424"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4173"
reproduced: true
---

# `cannot call %s on a non-array`

## What it means

A JSON function that operates on array structure was called on a JSON value that is not an array. The placeholder names the function. The value was an object, string, number, or another scalar, so array semantics do not apply.

## When it happens

Calling a function such as `jsonb_array_elements()` or `json_array_length()` on a JSON value that turns out to be an object or scalar rather than an array — often because the input shape varies row to row.

## How to fix

Check the JSON type before calling the function, for example with `jsonb_typeof(val) = 'array'` in a `WHERE` or `CASE`. Correct the query path so array functions only receive arrays, or coerce the data into arrays first.

## Example

*Reproduced* — captured from `reproducers/scenarios/19_json_sqljson.sql`.

```sql
SELECT jsonb_populate_recordset(NULL::repro.parent, '{"id":1}');
```

Produces:

```text
ERROR:  cannot call jsonb_populate_recordset on a non-array
```

## Related

- [cannot get array length of a non-array](./cannot-get-array-length-of-a-non-array.md)
- [cannot get array length of a scalar](./cannot-get-array-length-of-a-scalar.md)
