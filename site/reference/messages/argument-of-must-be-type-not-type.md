---
message: "argument of %s must be type %s, not type %s"
slug: argument-of-must-be-type-not-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:1174"
  - "postgres/src/backend/parser/parse_coerce.c:1222"
reproduced: false
---

# `argument of %s must be type %s, not type %s`

## What it means

A construct required its argument to be a specific type and received a different one. The message names the construct, the expected type, and the type actually supplied. It arises where an argument's type is fixed by the surrounding syntax rather than coercible on the spot.

## When it happens

Placing an expression of the wrong type where a construct demands a particular one — for example a clause that requires a boolean, an integer, or another exact type, given something that does not match and cannot be implicitly coerced there.

## How to fix

Convert the argument to the required type or replace it with an expression of that type. Add an explicit cast, or correct the expression so it yields the expected type. The message names both the required and the supplied type, which points directly at the mismatch.

## Example

*Illustrative* — an argument of the wrong type.

```sql
SELECT * FROM t LIMIT 'x';  -- argument of LIMIT must be type integer, not type text
```

## Related

- [argument of must not return a set](./argument-of-must-not-return-a-set.md)
- [argument of must be an array of objects](./argument-of-must-be-an-array-of-objects.md)
