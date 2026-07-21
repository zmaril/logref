---
message: "array element type cannot be %s"
slug: array-element-type-cannot-be
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:405"
reproduced: false
---

# `array element type cannot be %s`

## What it means

An array was defined or constructed over an element type that is not permitted as an array element, so the array type cannot be formed.

## When it happens

It occurs when creating an array of a pseudo-type or another disallowed type — for example trying to build an array whose element type cannot itself be stored in an array.

## How to fix

Choose an element type that can be placed in an array (ordinary base, composite, enum, or range types). Avoid pseudo-types and other types that are not valid array elements; restructure the data model if you were relying on an unsupported element type.

## Example

*Illustrative* — an array over a disallowed element type.

```text
ERROR:  array element type cannot be "unknown"
```

## Related

- [array of serial is not implemented](./array-of-serial-is-not-implemented.md)
- [array data types are not binary-compatible](./array-data-types-are-not-binary-compatible.md)
