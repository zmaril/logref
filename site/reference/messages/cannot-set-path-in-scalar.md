---
message: "cannot set path in scalar"
slug: cannot-set-path-in-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4877"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5026"
reproduced: false
---

# `cannot set path in scalar`

## What it means

A `jsonb_set()`-style path update tried to descend into a JSON scalar (string, number, boolean, or null) as if it were an object or array. A scalar has no interior path to set, so the operation has no target.

## When it happens

Applying a path-based JSON update where the path leads into a scalar value rather than an object or array — often because the data's shape at that path differs from what the query assumes.

## How to fix

Verify the JSON structure at the path before setting into it, using `jsonb_typeof()` or by inspecting sample rows. Set paths only where the intermediate value is an object or array, and handle scalar cases separately.

## Example

*Illustrative* — setting a path inside a scalar.

```sql
SELECT jsonb_set('{"a":5}', '{a,b}', '1');
-- ERROR:  cannot set path in scalar
```

## Related

- [cannot get array length of a scalar](./cannot-get-array-length-of-a-scalar.md)
- [cannot call on a non-array](./cannot-call-on-a-non-array.md)
