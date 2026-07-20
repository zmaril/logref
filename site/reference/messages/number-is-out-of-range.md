---
message: "number is out of range"
slug: number-is-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:5073"
  - "postgres/src/backend/utils/adt/varlena.c:5255"
reproduced: false
---

# `number is out of range`

## What it means

A numeric value or intermediate result exceeded the range representable for the type involved. The value cannot be stored or computed without overflow.

## When it happens

It arises in numeric parsing and arithmetic — casting a too-large literal, an overflowing multiplication, or a conversion whose result does not fit the target type.

## How to fix

Use a wider numeric type (for example `bigint` or `numeric`) where the values or intermediate results are large, or scale the computation to stay within range. Validate inputs that could exceed the type's limits before the operation.

## Example

*Illustrative* — a value beyond the type's range.

```sql
SELECT 9999999999::integer;  -- number is out of range
```

## Related

- [must be in range](./must-be-in-range-979b1e.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-6582cf.md)
