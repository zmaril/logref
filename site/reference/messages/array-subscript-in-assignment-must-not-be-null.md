---
message: "array subscript in assignment must not be null"
slug: array-subscript-in-assignment-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/arraysubs.c:198"
  - "postgres/src/backend/utils/adt/arraysubs.c:217"
reproduced: false
---

# `array subscript in assignment must not be null`

## What it means

An assignment to an array element used a null subscript. Assigning into an array at a null position is not defined, so it is rejected rather than silently ignored.

## When it happens

Writing an update or PL/pgSQL assignment like `arr[i] := v` where the subscript `i` evaluated to `NULL`, usually because the index came from an expression or variable that was null.

## How to fix

Ensure the subscript is non-null before assigning. Guard the index with a null check or `COALESCE`, and trace why it was null — often a missing lookup or an uninitialized variable feeding the subscript.

## Example

*Illustrative* — a null array subscript in assignment.

```sql
arr[idx] := 5;  -- fails when idx is null
```

## Related

- [array subscript must have type integer](./array-subscript-must-have-type-integer.md)
- [null value not allowed for hstore key](./null-value-not-allowed-for-hstore-key.md)
