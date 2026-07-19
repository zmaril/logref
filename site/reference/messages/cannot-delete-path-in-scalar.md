---
message: "cannot delete path in scalar"
slug: cannot-delete-path-in-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4981"
reproduced: false
---

# `cannot delete path in scalar`

## What it means

A JSON path-deletion operation reached a scalar where it was told to remove a path element. Scalars have no internal members, so a path cannot be deleted from within one.

## When it happens

It occurs when a function such as `jsonb_delete` with a path, or the `#-` operator, descends to a scalar and then tries to delete a further element.

## How to fix

Stop the deletion path at objects or arrays, which have members to remove. Adjust the path so it does not attempt to delete inside a scalar value.

## Example

*Illustrative* — deleting inside a scalar.

```sql
SELECT '5'::jsonb #- '{a}';
```

## Related

- [cannot delete from object using integer index](./cannot-delete-from-object-using-integer-index.md)
- [cannot deconstruct a scalar](./cannot-deconstruct-a-scalar.md)
