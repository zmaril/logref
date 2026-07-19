---
message: "a negative integer value cannot be specified for %s"
slug: a-negative-integer-value-cannot-be-specified-for
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:462"
reproduced: false
---

# `a negative integer value cannot be specified for %s`

## What it means

A parameter that only accepts zero or positive integers was given a negative value, so the setting was rejected.

## When it happens

It occurs when a `SET`, storage parameter, or tool option that represents a count, size, or limit is assigned a negative number.

## How to fix

Supply a non-negative value for the named parameter. Check what the parameter means — many use `0` or a special sentinel to mean disabled or unlimited, so pick the intended non-negative value rather than a negative one.

## Example

*Illustrative* — a negative value for a count parameter.

```text
ERROR:  a negative integer value cannot be specified for max_retries
```

## Related

- [should be less than or equal to](./should-be-less-than-or-equal-to.md)
- [argument of ntile must be greater than zero](./argument-of-ntile-must-be-greater-than-zero.md)
