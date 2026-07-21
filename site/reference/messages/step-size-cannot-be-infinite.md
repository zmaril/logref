---
message: "step size cannot be infinite"
slug: step-size-cannot-be-infinite
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:6763"
  - "postgres/src/backend/utils/adt/timestamp.c:6849"
reproduced: false
---

# `step size cannot be infinite`

## What it means

A step/stride argument that must be a finite quantity was given as infinity. The operation increments a value by this step, which cannot be an infinite amount.

## When it happens

It arises from `generate_series` or a binning/stepping function when the step argument is `'infinity'` (for numeric or interval-like steps).

## How to fix

Pass a finite, non-zero step. Choose a concrete increment appropriate to the range; an infinite step has no meaningful iteration semantics.

## Example

*Illustrative* — an infinite step passed to a stepping function.

```text
ERROR:  step size cannot be infinite
```

## Related

- [stride must be greater than zero](./stride-must-be-greater-than-zero.md)
- [timestamps cannot be binned into infinite intervals](./timestamps-cannot-be-binned-into-infinite-intervals.md)
