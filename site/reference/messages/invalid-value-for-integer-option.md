---
message: "invalid value for integer option \"%s\": %s"
slug: invalid-value-for-integer-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/postgres_fdw/option.c:172"
  - "postgres/src/backend/access/common/reloptions.c:1739"
reproduced: false
---

# `invalid value for integer option "%s": %s`

## What it means

An option that expects an integer was given a value that does not parse as one. The placeholders name the option and the rejected value.

## When it happens

It arises in option lists — foreign-data-wrapper or extension options, and some tool settings — when an integer option receives non-integer text, a fractional value, or an out-of-range number.

## How to fix

Give the option a whole-number value within its documented range. Remove decimal points, units, and other characters. Check the option's documentation for the accepted bounds.

## Example

*Illustrative* — a non-integer value for an integer option.

```sql
OPTIONS ( fetch_size '1.5' )  -- expects an integer
```

## Related

- [invalid value for boolean option](./invalid-value-for-boolean-option.md)
- [invalid value for floating point option](./invalid-value-for-floating-point-option.md)
