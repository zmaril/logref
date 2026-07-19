---
message: "array subscript must have type integer"
slug: array-subscript-must-have-type-integer
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/arraysubs.c:93"
  - "postgres/src/backend/utils/adt/arraysubs.c:130"
reproduced: false
---

# `array subscript must have type integer`

## What it means

An array subscript expression was not of integer type. Array positions are addressed by integers, so a subscript that is text, floating point, or another non-integer type is invalid.

## When it happens

Subscripting an array with a non-integer expression — for example a text value that was not cast, or a numeric expression that produced a non-integer type — in a query or assignment.

## How to fix

Provide an integer subscript. Cast the expression to `integer`, or correct it so it yields an integer. If the subscript comes from user input or a computed value, convert it explicitly before using it as an index.

## Example

*Illustrative* — a non-integer subscript.

```sql
SELECT arr['1'] FROM t;  -- subscript must be integer
```

## Related

- [array subscript in assignment must not be null](./array-subscript-in-assignment-must-not-be-null.md)
- [upper bound cannot be less than lower bound](./upper-bound-cannot-be-less-than-lower-bound.md)
