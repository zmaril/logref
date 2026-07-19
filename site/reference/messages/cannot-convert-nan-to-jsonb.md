---
message: "cannot convert NaN to jsonb"
slug: cannot-convert-nan-to-jsonb
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/jsonb_plperl/jsonb_plperl.c:255"
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:408"
reproduced: false
---

# `cannot convert NaN to jsonb`

## What it means

A conversion into `jsonb` received a floating-point NaN (not-a-number). JSON has no representation for NaN, so the value cannot be stored as a JSON number. This arises inside the PL/Perl and PL/Python jsonb transforms.

## When it happens

Returning or building a `jsonb` value from PL/Perl or PL/Python where a number is NaN, or converting a numeric column containing NaN into JSON through those transforms.

## How to fix

Replace NaN values before converting to `jsonb` — map them to `null`, a sentinel string, or a defined default. JSON cannot represent NaN, so decide explicitly how such values should appear.

## Example

*Illustrative* — a NaN float converted to jsonb.

```text
ERROR:  cannot convert NaN to jsonb
```

## Related

- [cannot convert infinity to jsonb](./cannot-convert-infinity-to-jsonb.md)
- [cannot call on a non-array](./cannot-call-on-a-non-array.md)
