---
message: "could not find function \"%s\" in library \"%s\" for injection point \"%s\""
slug: could-not-find-function-in-library-for-injection-point
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/injection_point.c:197"
reproduced: false
---

# `could not find function "%s" in library "%s" for injection point "%s"`

## What it means

The injection-point machinery could not find the named callback function in the named library. The `%s` values give the function, library, and injection point. Injection points are an internal testing facility.

## When it happens

It fires when an injection point is triggered but its registered callback symbol is missing from the library — a build-time testing feature, not part of normal operation.

## How to fix

This concerns the injection-point test facility (built only with the relevant option). Confirm the test library exports the named function and matches the registered injection point. It does not arise in ordinary production use.

## Example

*Illustrative* — a missing injection-point callback.

```text
ERROR:  could not find function "my_ip_cb" in library "test_injection.so" for injection point "my-point"
```

## Related

- [could not find library for injection point](./could-not-find-library-for-injection-point.md)
- [could not find function in file](./could-not-find-function-in-file.md)
