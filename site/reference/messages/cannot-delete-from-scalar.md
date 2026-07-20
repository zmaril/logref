---
message: "cannot delete from scalar"
slug: cannot-delete-from-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4674"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4730"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4807"
reproduced: false
---

# `cannot delete from scalar`

## What it means

A JSON delete operation targeted a scalar value rather than an object or array. The `jsonb` delete operators and functions remove a key or element; a bare scalar (number, string, boolean) has neither, so there is nothing to delete from.

## When it happens

Applying a `-` delete operator or `jsonb_set`/path-delete to a `jsonb` value that is a scalar at the targeted level, often because the path reached a leaf instead of a container.

## How to fix

Delete only from objects or arrays. Check the value's shape at the path you are deleting from (`jsonb_typeof`), and adjust the path so it points at a container. If you meant to remove the scalar itself, delete its key or index from the enclosing object/array.

## Example

*Illustrative* — deleting from a scalar leaf.

```sql
SELECT '5'::jsonb - 'k';  -- cannot delete from scalar
```

## Related

- [cannot call on an array](./cannot-call-on-an-array.md)
- [cannot replace existing key](./cannot-replace-existing-key.md)
