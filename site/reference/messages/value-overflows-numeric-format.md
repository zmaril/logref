---
message: "value overflows numeric format"
slug: value-overflows-numeric-format
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:3629"
  - "postgres/src/backend/utils/adt/numeric.c:10474"
  - "postgres/src/backend/utils/adt/numeric.c:10949"
  - "postgres/src/backend/utils/adt/numeric.c:11043"
  - "postgres/src/backend/utils/adt/numeric.c:11178"
reproduced: true
---

# `value overflows numeric format`

## What it means

A `numeric` value exceeded the internal representation's limits. Although `numeric` supports a very large range, its on-disk format bounds the number of digits and the weight (magnitude); a value beyond those bounds cannot be represented.

## When it happens

Producing a `numeric` with an extreme magnitude — for example repeated multiplication or exponentiation (`10 ^ 1000000`) that pushes the value past the format's digit/weight limits.

## How to fix

Reduce the magnitude of the computation. `numeric` supports up to 131072 digits before the decimal point and 16383 after, but expressions like large exponentials can exceed even that. Rework the calculation, use logarithms for very large products, or store results that fit the representable range.

## Example

*Reproduced* — captured from `reproducers/scenarios/32_adt_arithmetic_overflow.sql`.

```sql
SELECT exp(1000000::numeric);
```

Produces:

```text
ERROR:  value overflows numeric format
```

## Related

- [money out of range](./money-out-of-range.md)
- [smallint out of range](./smallint-out-of-range.md)
