---
message: "ACL arrays must be one-dimensional"
slug: acl-arrays-must-be-one-dimensional
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:611"
reproduced: false
---

# `ACL arrays must be one-dimensional`

## What it means

A value used as an access-control list was a multidimensional array, but ACLs must be a single-dimension array of `aclitem` entries.

## When it happens

It occurs when an ACL function receives an array with more than one dimension, typically from a hand-built or mis-cast array.

## How to fix

Provide a one-dimensional `aclitem[]`. Flatten or rebuild the array so it has a single dimension. ACL values from the catalog are already one-dimensional, so this usually points at a constructed value.

## Example

*Illustrative* — a two-dimensional array used as an ACL.

```text
ERROR:  ACL arrays must be one-dimensional
```

## Related

- [ACL array contains wrong data type](./acl-array-contains-wrong-data-type.md)
- [ACL arrays must not contain null values](./acl-arrays-must-not-contain-null-values.md)
