---
message: "invalid value for floating point option \"%s\": %s"
slug: invalid-value-for-floating-point-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/postgres_fdw/option.c:145"
  - "postgres/src/backend/access/common/reloptions.c:1759"
reproduced: true
---

# `invalid value for floating point option "%s": %s`

## What it means

An option that expects a floating-point number was given a value that does not parse as one. The placeholders name the option and the rejected value.

## When it happens

It arises in option lists — foreign-data-wrapper or extension options, and some tool settings — when a numeric option receives text that is not a valid float.

## How to fix

Give the option a valid floating-point value, such as `0.5` or `1e3`. Remove units, currency signs, or stray characters, and match the option's documented range.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at ALTER COLUMN a SET (n_distinct = 'x');
```

Produces:

```text
ERROR:  invalid value for floating point option "n_distinct": x
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [invalid value for boolean option](./invalid-value-for-boolean-option.md)
