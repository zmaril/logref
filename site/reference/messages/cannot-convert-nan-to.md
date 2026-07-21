---
message: "cannot convert NaN to %s"
slug: cannot-convert-nan-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:4723"
reproduced: false
---

# `cannot convert NaN to %s`

## What it means

A conversion tried to turn a floating-point NaN (not-a-number) into a type that has no representation for it — for example a `numeric` or an integer. The placeholder is the target type. NaN cannot be represented there.

## When it happens

It occurs when casting or converting a `float` value of `NaN` into a type that does not support it.

## How to fix

Filter out NaN values before converting, or keep them in a floating-point type. Decide how NaN should be handled for the target type and address it explicitly in the query.

## Example

*Illustrative* — converting NaN.

```sql
SELECT ('NaN'::float8)::numeric;
```

## Related

- [cannot convert infinity to](./cannot-convert-infinity-to.md)
- [cannot coerce to double](./cannot-coerce-to-double.md)
