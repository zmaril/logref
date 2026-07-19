---
message: "invalid type modifier"
slug: invalid-type-modifier
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:56"
  - "postgres/src/backend/utils/adt/timestamp.c:107"
  - "postgres/src/backend/utils/adt/varbit.c:103"
  - "postgres/src/backend/utils/adt/varchar.c:46"
reproduced: false
---

# `invalid type modifier`

## What it means

A type modifier (the parenthesized value after a type name, like the precision in `time(6)`) was invalid for the type. The placeholder-free text covers cases such as an out-of-range or malformed modifier on date/time and related types.

## When it happens

Declaring or casting to a type with a bad modifier — for example a fractional-seconds precision outside the allowed range on `time`/`timestamp`, or a modifier where the type accepts none.

## How to fix

Use a modifier within the type's allowed range (for time/timestamp precision, 0 to 6), or omit it if the type takes no modifier. Consult the type's documentation for the valid modifier form and bounds.

## Example

*Illustrative* — an out-of-range time precision.

```sql
SELECT '12:00'::time(9);
```

## Related

- [date out of range](./date-out-of-range-4f42a7.md)
- [alignment is invalid for passed-by-value type of size](./alignment-is-invalid-for-passed-by-value-type-of-size.md)
