---
message: "ACL array contains wrong data type"
slug: acl-array-contains-wrong-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:607"
reproduced: false
---

# `ACL array contains wrong data type`

## What it means

A value being interpreted as an access-control list (ACL) array held elements of the wrong data type, so it could not be parsed as a set of `aclitem` entries.

## When it happens

It occurs when a function or catalog operation is handed an array that should contain `aclitem` values but contains something else, for example a hand-constructed array passed to an ACL function.

## How to fix

Supply a proper `aclitem[]` value. ACLs are normally produced by the system (in catalog columns like `relacl`) rather than built by hand; if you are constructing one, ensure every element is a valid `aclitem`. Do not cast unrelated arrays into ACL contexts.

## Example

*Illustrative* — a non-aclitem array used where an ACL is expected.

```text
ERROR:  ACL array contains wrong data type
```

## Related

- [ACL arrays must be one-dimensional](./acl-arrays-must-be-one-dimensional.md)
- [ACL arrays must not contain null values](./acl-arrays-must-not-contain-null-values.md)
