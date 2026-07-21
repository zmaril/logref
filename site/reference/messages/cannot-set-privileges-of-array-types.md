---
message: "cannot set privileges of array types"
slug: cannot-set-privileges-of-array-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2429"
reproduced: false
---

# `cannot set privileges of array types`

## What it means

A `GRANT` or `REVOKE` targeted an array type directly. An array type's privileges are governed by its element type, so they cannot be set on the array type on its own.

## When it happens

It occurs when a privilege command names an array type (for example `integer[]`) as the object whose privileges are changed.

## How to fix

Grant or revoke privileges on the element (base) type instead; the array type inherits from it. Target the underlying scalar type in the command.

## Example

*Illustrative* — granting on an array type.

```text
ERROR:  cannot set privileges of array types
```

## Related

- [cannot set privileges of multirange types](./cannot-set-privileges-of-multirange-types.md)
- [cannot set security label on relation](./cannot-set-security-label-on-relation.md)
