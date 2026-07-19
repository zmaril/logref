---
message: "subscript type %s is not supported"
slug: subscript-type-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/jsonbsubs.c:99"
  - "postgres/src/backend/utils/adt/jsonbsubs.c:113"
reproduced: false
---

# `subscript type %s is not supported`

## What it means

A subscripting expression (`value[...]`) was applied with a subscript of a type the container does not accept. The placeholder is the subscript type. Each subscriptable type defines which subscript types are valid.

## When it happens

It arises when subscripting an array or a custom subscriptable type with a subscript expression of the wrong type — for example a non-integer subscript on an array, or a type a custom subscript handler rejects.

## How to fix

Use a subscript of the expected type (integers for arrays; whatever a custom type's subscript handler defines). Cast the subscript expression to the required type if it is currently something else.

## Example

*Illustrative* — an unsupported subscript type.

```text
ERROR:  subscript type text is not supported
```

## Related

- [type %s does not support subscripted assignment](./type-does-not-support-subscripted-assignment.md)
- [source array too small](./source-array-too-small.md)
