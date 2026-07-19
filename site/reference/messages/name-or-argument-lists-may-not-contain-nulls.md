---
message: "name or argument lists may not contain nulls"
slug: name-or-argument-lists-may-not-contain-nulls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2197"
  - "postgres/src/backend/catalog/objectaddress.c:2254"
  - "postgres/src/backend/catalog/objectaddress.c:2309"
reproduced: false
---

# `name or argument lists may not contain nulls`

## What it means

An object-addressing call passed a name list or argument-type list that contained a null element. These lists identify a database object by name and argument types, and every element must be non-null.

## When it happens

Calling a system function that identifies an object by arrays of names and argument types, when one of those array elements is `NULL` — often because the array was built from a query that produced a null.

## How to fix

Remove the nulls from the name and argument arrays before the call. Check the query or expression that assembles the arrays, and ensure every element is a valid non-null identifier or type name.

## Example

*Illustrative* — a null element in a name list.

```text
ERROR:  name or argument lists may not contain nulls
```

## Related

- [name list length must be at least](./name-list-length-must-be-at-least.md)
- [argument list length must be exactly](./argument-list-length-must-be-exactly.md)
