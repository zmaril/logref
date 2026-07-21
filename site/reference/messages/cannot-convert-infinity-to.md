---
message: "cannot convert infinity to %s"
slug: cannot-convert-infinity-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:4727"
reproduced: false
---

# `cannot convert infinity to %s`

## What it means

A conversion tried to turn a floating-point infinity into a type that has no representation for infinity — for example a `numeric` or an integer. The placeholder is the target type. Infinite values cannot be represented there.

## When it happens

It occurs when casting or converting a `float` value of `Infinity`/`-Infinity` into a type that does not support infinity.

## How to fix

Filter or clamp infinite values before converting, or keep them in a floating-point type that represents infinity. Decide how infinities should map to the target domain and handle them explicitly.

## Example

*Illustrative* — converting infinity.

```sql
SELECT ('Infinity'::float8)::numeric;
```

## Related

- [cannot convert nan to](./cannot-convert-nan-to.md)
- [cannot convert value from to without time zone usage](./cannot-convert-value-from-to-without-time-zone-usage.md)
