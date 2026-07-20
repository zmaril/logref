---
message: "value for \"%s\" is too long"
slug: value-for-is-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/tsearch/wparser_def.c:2682"
  - "postgres/src/backend/tsearch/wparser_def.c:2686"
  - "postgres/src/backend/tsearch/wparser_def.c:2690"
reproduced: false
---

# `value for "%s" is too long`

## What it means

A value supplied for a text-search parser option exceeded the allowed length. The option accepts a bounded string, and the value given was longer than the limit.

## When it happens

Configuring a text-search parser or dictionary option (for example within header-parsing configuration) with a value that is longer than the option permits.

## How to fix

Shorten the value to fit the option's length limit. Check the option's documented maximum, and trim or restructure the value so it fits.

## Example

*Illustrative* — an over-length option value.

```text
ERROR:  value for "host" is too long
```

## Related

- [invalid value for option](./invalid-value-for-option.md)
- [cannot specify parameter](./cannot-specify-parameter.md)
