---
message: "date out of range"
slug: date-out-of-range-4f42a7
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:216"
  - "postgres/src/backend/utils/adt/date.c:580"
  - "postgres/src/backend/utils/adt/date.c:605"
  - "postgres/src/backend/utils/adt/xml.c:2594"
reproduced: false
---

# `date out of range`

## What it means

A `date` value fell outside the range the type can represent. The placeholder-free text signals that a date computation or conversion produced a value beyond the supported bounds (roughly 4714 BC to 5874897 AD for `date`).

## When it happens

Date arithmetic that overflows (adding a large interval), converting an out-of-range value to `date`, or parsing a year outside the supported range.

## How to fix

Keep dates within the representable range. Validate inputs before conversion, and guard arithmetic that could push a date past the bounds. If you need to represent dates beyond `date`'s range, reconsider the modeling — there is no wider built-in date type.

## Example

*Illustrative* — date arithmetic that overflows.

```sql
SELECT 'infinity'::date + 1;  -- or a computation past the supported range
```

## Related

- [value overflows numeric format](./value-overflows-numeric-format.md)
- [invalid type modifier](./invalid-type-modifier.md)
