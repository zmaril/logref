---
message: "cannot call %s on a scalar"
slug: cannot-call-on-a-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:586"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:833"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2439"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:3948"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4295"
reproduced: false
---

# `cannot call %s on a scalar`

## What it means

A JSON accessor function that expects an object or array was applied to a JSON scalar (a lone string, number, boolean, or null). The placeholder is the function name. Functions like `jsonb_object_keys` or `jsonb_each` have no meaning on a scalar value.

## When it happens

Calling an object/array-oriented JSON function on a value that is actually a scalar — for example `jsonb_object_keys('42'::jsonb)` or applying `jsonb_array_elements` to a non-array.

## How to fix

Check the shape of the value before calling the function. Use `jsonb_typeof(value)` to branch, or restrict the query to rows whose value is an object/array. If a scalar is expected, use `->>`, `#>>`, or a cast to extract it instead.

## Example

*Illustrative* — object keys requested from a scalar.

```sql
SELECT jsonb_object_keys('42'::jsonb);
```

## Related

- [null value not allowed for object key](./null-value-not-allowed-for-object-key.md)
- [cannot display a value of type](./cannot-display-a-value-of-type.md)
