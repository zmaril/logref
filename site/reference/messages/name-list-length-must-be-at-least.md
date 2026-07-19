---
message: "name list length must be at least %d"
slug: name-list-length-must-be-at-least
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2280"
  - "postgres/src/backend/catalog/objectaddress.c:2350"
  - "postgres/src/backend/catalog/objectaddress.c:2357"
reproduced: false
---

# `name list length must be at least %d`

## What it means

An object was addressed by a name list that was too short. Some object kinds require a name list of a minimum length — for example a schema-qualified name needs at least two elements — and the list supplied had fewer.

## When it happens

Calling an object-addressing function or system operation (such as those behind `pg_identify_object` or extension dependency handling) with a name array that has fewer elements than the object type requires.

## How to fix

Supply a name list with enough elements for the object type. Consult the addressing rules for the object kind you are naming, and include every required qualifier, such as the schema, so the list meets the minimum length.

## Example

*Illustrative* — a too-short name list.

```text
ERROR:  name list length must be at least 2
```

## Related

- [name or argument lists may not contain nulls](./name-or-argument-lists-may-not-contain-nulls.md)
- [argument list length must be exactly](./argument-list-length-must-be-exactly.md)
