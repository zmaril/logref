---
message: "cannot convert infinity to jsonb"
slug: cannot-convert-infinity-to-jsonb
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:251"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:412"
reproduced: false
---

# `cannot convert infinity to jsonb`

## What it means

A conversion into `jsonb` received a floating-point infinity. JSON has no representation for infinity, so the value cannot be stored as a JSON number. This arises inside the PL/Perl and PL/Python jsonb transforms.

## When it happens

Returning or building a `jsonb` value from PL/Perl or PL/Python where a number is `Inf` or `-Inf`, or converting a numeric column containing infinity into JSON through those transforms.

## How to fix

Replace infinite values before converting to `jsonb` — map them to a sentinel string, `null`, or a finite bound that your consumers understand. JSON cannot carry infinity, so the representation choice is yours to make explicit.

## Example

*Illustrative* — an infinite float converted to jsonb.

```text
ERROR:  cannot convert infinity to jsonb
```

## Related

- [cannot convert NaN to jsonb](./cannot-convert-nan-to-jsonb.md)
- [cannot add infinite interval to time](./cannot-add-infinite-interval-to-time.md)
