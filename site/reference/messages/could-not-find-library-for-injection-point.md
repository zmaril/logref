---
message: "could not find library \"%s\" for injection point \"%s\""
slug: could-not-find-library-for-injection-point
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/injection_point.c:190"
reproduced: false
---

# `could not find library "%s" for injection point "%s"`

## What it means

The injection-point machinery could not load or find the library registered for an injection point. The `%s` values name the library and the injection point. Injection points are an internal testing facility.

## When it happens

It fires when an injection point is triggered but its library cannot be located — a build-time testing feature, not part of normal operation.

## How to fix

This concerns the injection-point test facility (built only with the relevant option). Confirm the test library is installed where expected and matches the registered injection point. It does not arise in ordinary production use.

## Example

*Illustrative* — a missing injection-point library.

```text
ERROR:  could not find library "test_injection.so" for injection point "my-point"
```

## Related

- [could not find function in library for injection point](./could-not-find-function-in-library-for-injection-point.md)
- [could not find function in file](./could-not-find-function-in-file.md)
