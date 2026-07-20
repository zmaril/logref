---
message: "argument of %s must be an array of objects"
slug: argument-of-must-be-an-array-of-objects
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4190"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4274"
reproduced: false
---

# `argument of %s must be an array of objects`

## What it means

A JSON-processing function expected its argument to be a JSON array whose elements are objects, and it was given something else. The function iterates over object elements, so a non-array or an array containing non-object elements is rejected.

## When it happens

Calling a function such as `json_populate_recordset` or `jsonb_populate_recordset` (and similar set-building functions) with an argument that is not a JSON array of objects — for example a bare object, a scalar, or an array of scalars.

## How to fix

Pass a JSON array whose every element is an object, matching the shape the function expects to expand into rows. Wrap a single object in an array if needed, and check that the source JSON was not a scalar or a differently shaped structure.

## Example

*Illustrative* — a non-array argument.

```sql
SELECT * FROM json_populate_recordset(null::t, '{"a":1}');  -- must be an array of objects
```

## Related

- [argument of must not return a set](./argument-of-must-not-return-a-set.md)
- [argument of must be type not type](./argument-of-must-be-type-not-type.md)
