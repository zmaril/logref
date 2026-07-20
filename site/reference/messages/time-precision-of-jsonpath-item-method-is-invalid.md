---
message: "time precision of jsonpath item method .%s() is invalid"
slug: time-precision-of-jsonpath-item-method-is-invalid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_SQL_JSON_DATETIME_FUNCTION
    code: "22031"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2779"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:2860"
reproduced: false
---

# `time precision of jsonpath item method .%s() is invalid`

## What it means

A jsonpath datetime item method (such as `.time()` or `.timestamp()`) was given a precision argument outside the allowed range. The placeholder is the method name. Fractional-seconds precision must fall within the supported bounds.

## When it happens

It arises when evaluating a jsonpath expression whose datetime method specifies an invalid precision — for example a negative value or one above the maximum fractional-seconds precision.

## How to fix

Use a precision within the valid range (0 up to the maximum supported fractional-seconds precision). Correct the jsonpath method's precision argument accordingly.

## Example

*Illustrative* — an invalid precision on a jsonpath time method.

```text
ERROR:  time precision of jsonpath item method .time() is invalid
```

## Related

- [time field value out of range: %d:%02d:%02g](./time-field-value-out-of-range.md)
- [step size cannot be infinite](./step-size-cannot-be-infinite.md)
