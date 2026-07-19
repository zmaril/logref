---
message: "cannot delete from object using integer index"
slug: cannot-delete-from-object-using-integer-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4812"
reproduced: false
---

# `cannot delete from object using integer index`

## What it means

A JSON manipulation function used an integer index to delete from an object. Objects are keyed by name, not by position, so an integer index cannot select a member to remove.

## When it happens

It occurs when a function such as `jsonb_delete` (or the `#-` path operator) applies an integer path element to a JSON object.

## How to fix

Use a text key to delete from an object, and an integer index only for arrays. Adjust the path element to match whether the target is an object or an array.

## Example

*Illustrative* — an integer index into an object.

```sql
SELECT '{"a":1}'::jsonb #- '{0}';
```

## Related

- [cannot delete path in scalar](./cannot-delete-path-in-scalar.md)
- [cannot deconstruct an array as an object](./cannot-deconstruct-an-array-as-an-object.md)
