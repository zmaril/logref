---
message: "cannot specify parameter \"%s\""
slug: cannot-specify-parameter
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/extended_stats_funcs.c:482"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:499"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:561"
reproduced: false
---

# `cannot specify parameter "%s"`

## What it means

A statistics-manipulation function was told a parameter cannot be set in the context it was given. The named parameter is not accepted for this operation, so supplying it is rejected with a warning.

## When it happens

Calling a function that imports or sets extended-statistics data with a parameter that does not apply to the kind of statistics being written — for example specifying an option that only certain statistic kinds accept.

## Is this a problem?

This is a warning: the operation may continue, but the parameter you named had no valid place here. Remove the inapplicable parameter, and consult the function's documentation for which parameters apply to the statistic kind you are setting.

## Example

*Illustrative* — an inapplicable statistics parameter.

```text
WARNING:  cannot specify parameter "n_distinct"
```

## Related

- [statistics creation on system columns is not supported](./statistics-creation-on-system-columns-is-not-supported.md)
- [invalid value for option](./invalid-value-for-option.md)
