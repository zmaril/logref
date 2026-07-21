---
message: "argument list length must be exactly %d"
slug: argument-list-length-must-be-exactly
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2343"
  - "postgres/src/backend/catalog/objectaddress.c:2364"
reproduced: false
---

# `argument list length must be exactly %d`

## What it means

An object-addressing call supplied an argument-type list of the wrong length. Identifying a routine or object requires exactly the number of argument types the object type calls for, and the list did not have that many.

## When it happens

Calling a system function that addresses an object by name and argument types with an argument array that has too few or too many elements for the object being identified.

## How to fix

Supply an argument-type list of the exact required length. Check how many argument types the object type expects, and build the array to match, in the correct order.

## Example

*Illustrative* — a wrong-length argument list.

```text
ERROR:  argument list length must be exactly 1
```

## Related

- [name list length must be at least](./name-list-length-must-be-at-least.md)
- [name or argument lists may not contain nulls](./name-or-argument-lists-may-not-contain-nulls.md)
