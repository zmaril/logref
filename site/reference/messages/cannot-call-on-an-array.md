---
message: "cannot call %s on an array"
slug: cannot-call-on-an-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:591"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:818"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:3935"
reproduced: false
---

# `cannot call %s on an array`

## What it means

A JSON accessor function that expects a scalar or object was invoked on a JSON array. The placeholder names the function. Some `jsonb`/`json` functions are defined only for object or scalar inputs; applying them to an array is a type-shape error.

## When it happens

Calling a function such as one that extracts an object field on a value that is actually a JSON array, often because the JSON structure differed from what the query assumed.

## How to fix

Match the function to the JSON shape: use array-oriented functions (`jsonb_array_elements`, subscripting by index) for arrays, and object/scalar functions for those. Inspect the value's `jsonb_typeof` first if the structure is not guaranteed, and branch accordingly.

## Example

*Illustrative* — an object accessor on an array.

```sql
SELECT jsonb_object_keys('[1,2,3]'::jsonb);  -- cannot call on an array
```

## Related

- [cannot delete from scalar](./cannot-delete-from-scalar.md)
- [cannot replace existing key](./cannot-replace-existing-key.md)
