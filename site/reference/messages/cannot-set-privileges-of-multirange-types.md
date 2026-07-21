---
message: "cannot set privileges of multirange types"
slug: cannot-set-privileges-of-multirange-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2434"
reproduced: false
---

# `cannot set privileges of multirange types`

## What it means

A `GRANT` or `REVOKE` targeted a multirange type directly. A multirange type's privileges follow its associated range type, so they cannot be set on the multirange type on its own.

## When it happens

It occurs when a privilege command names a multirange type as the object whose privileges are changed.

## How to fix

Grant or revoke privileges on the underlying range type instead; the multirange type follows from it. Target the range type in the command.

## Example

*Illustrative* — granting on a multirange type.

```text
ERROR:  cannot set privileges of multirange types
```

## Related

- [cannot set privileges of array types](./cannot-set-privileges-of-array-types.md)
- [cannot set security label on relation](./cannot-set-security-label-on-relation.md)
