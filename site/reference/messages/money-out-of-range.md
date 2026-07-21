---
message: "money out of range"
slug: money-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/btree_gist/btree_cash.c:106"
  - "postgres/src/backend/utils/adt/cash.c:97"
  - "postgres/src/backend/utils/adt/cash.c:110"
  - "postgres/src/backend/utils/adt/cash.c:123"
  - "postgres/src/backend/utils/adt/cash.c:136"
  - "postgres/src/backend/utils/adt/cash.c:149"
reproduced: false
---

# `money out of range`

## What it means

A `money` value did not fit its storage. Postgres stores `money` as a signed 64-bit integer of minor units (cents), so it holds roughly -92 quadrillion to +92 quadrillion major units at two decimal places. A conversion or arithmetic result outside that window is rejected rather than wrapped.

## When it happens

Casting a very large `numeric`/`float` to `money`, or `money` arithmetic (multiplication especially) whose result overflows the 64-bit range.

## How to fix

If the magnitude is legitimate, use `numeric` instead of `money` — it has effectively unbounded range and explicit scale. If it is not, validate the input before the cast. For intermediate overflow, restructure the arithmetic so the large factor is applied in `numeric` and cast to `money` only at the end.

## Example

*Illustrative* — a cast that overflows the money range.

```sql
SELECT '90000000000000000'::numeric::money;
```

## Related

- [value overflows numeric format](./value-overflows-numeric-format.md)
- [smallint out of range](./smallint-out-of-range.md)
