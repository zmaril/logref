---
message: "length for type %s must be at least 1"
slug: length-for-type-must-be-at-least-1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:108"
  - "postgres/src/backend/utils/adt/varchar.c:51"
reproduced: false
---

# `length for type %s must be at least 1`

## What it means

A type length modifier was zero or negative. The placeholder names the type. Length-qualified types require a positive length.

## When it happens

It arises from declarations like `varchar(0)`, `char(0)`, or `bit(0)` where the length is below one.

## How to fix

Specify a length of at least 1, or omit the length entirely where the type permits it (for example `varchar` without a bound behaves like `text`). Choose a length that fits the widest value you store.

## Example

*Illustrative* — a zero-length type modifier.

```sql
CREATE TABLE t (c char(0));  -- length must be at least 1
```

## Related

- [length for type cannot exceed](./length-for-type-cannot-exceed.md)
- [must be >= 0](./must-be-0.md)
