---
message: "cannot use \"V\" and decimal point together"
slug: cannot-use-v-and-decimal-point-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1247"
  - "postgres/src/backend/utils/adt/formatting.c:1334"
reproduced: false
---

# `cannot use "V" and decimal point together`

## What it means

A numeric `to_char`/`to_number` format template combined the `V` shift specifier with a decimal point. The placeholder is fixed text. `V` multiplies the value by a power of ten and is incompatible with an explicit decimal point in the same template.

## When it happens

Using a format string such as `'999V99.9'` that contains both `V` and `.` in `to_char()`, `to_number()`, or a related formatting call.

## How to fix

Choose one: use `V` for implicit decimal shifting, or a literal decimal point for explicit placement, but not both in the same template. Rewrite the format string to express the intended scaling with a single mechanism.

## Example

*Illustrative* — V and a decimal point together.

```sql
SELECT to_char(1.5, '9V9.9');
-- ERROR:  cannot use "V" and decimal point together
```

## Related

- [cannot be specified multiple times](./cannot-be-specified-multiple-times.md)
- [could not determine data type of input](./could-not-determine-data-type-of-input.md)
