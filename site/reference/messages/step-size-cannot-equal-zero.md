---
message: "step size cannot equal zero"
slug: step-size-cannot-equal-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/int.c:1557"
  - "postgres/src/backend/utils/adt/int8.c:1451"
  - "postgres/src/backend/utils/adt/numeric.c:1756"
  - "postgres/src/backend/utils/adt/timestamp.c:6758"
  - "postgres/src/backend/utils/adt/timestamp.c:6844"
reproduced: false
---

# `step size cannot equal zero`

## What it means

A `generate_series` call was given a step of zero. The series advances by the step each iteration; a zero step would never reach the end and never terminate, so it is rejected.

## When it happens

Calling `generate_series(start, stop, step)` for numeric or timestamp series with the `step` argument equal to zero — often because the step comes from an expression that evaluated to zero.

## How to fix

Pass a non-zero step whose sign moves `start` toward `stop`. If the step is computed, guard against a zero result before calling. Use a positive step for an ascending series and a negative step for a descending one.

## Example

*Illustrative* — a zero step in generate_series.

```sql
SELECT generate_series(1, 10, 0);
```

## Related

- [lower and upper bounds must be finite](./lower-and-upper-bounds-must-be-finite.md)
- [there is no parameter](./there-is-no-parameter.md)
