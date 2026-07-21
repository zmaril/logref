---
message: "ACL arrays must not contain null values"
slug: acl-arrays-must-not-contain-null-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:615"
reproduced: false
---

# `ACL arrays must not contain null values`

## What it means

A value used as an access-control list contained a NULL element, but every entry in an ACL array must be a non-null `aclitem`.

## When it happens

It occurs when an ACL function receives an array that includes a NULL, usually from a constructed or mis-cast value.

## How to fix

Remove nulls from the array so every element is a valid `aclitem`. Catalog ACLs never contain nulls; if you built the array yourself, ensure none of its elements are NULL.

## Example

*Illustrative* — a NULL element inside an ACL array.

```text
ERROR:  ACL arrays must not contain null values
```

## Related

- [ACL array contains wrong data type](./acl-array-contains-wrong-data-type.md)
- [ACL arrays must be one-dimensional](./acl-arrays-must-be-one-dimensional.md)
