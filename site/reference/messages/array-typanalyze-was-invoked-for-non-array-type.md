---
message: "array_typanalyze was invoked for non-array type %u"
slug: array-typanalyze-was-invoked-for-non-array-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/array_typanalyze.c:117"
reproduced: false
---

# `array_typanalyze was invoked for non-array type %u`

## What it means

The array type's statistics-gathering function (`array_typanalyze`) was invoked for a column whose type is not an array, which should never happen — an internal consistency guard.

## When it happens

It is raised during `ANALYZE` if the array typanalyze routine is associated with a non-array type, normally only through a mis-defined type or a bug.

## How to fix

This is an internal error, not a user query fault. It can indicate a custom type wrongly wired to the array analyze function. If an extension's type triggers it, report it there; otherwise capture the log and report it. There is no SQL-level workaround.

## Example

*Illustrative* — the array analyze routine on a non-array type.

```text
ERROR:  array_typanalyze was invoked for non-array type 16400
```

## Related

- [argument type of FieldStore is not a tuple type](./argument-type-of-fieldstore-is-not-a-tuple-type.md)
- [arraycontsel called for unrecognized operator](./arraycontsel-called-for-unrecognized-operator.md)
