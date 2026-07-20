---
message: "invalid Unicode code point: %04X"
slug: invalid-unicode-code-point
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:5686"
  - "postgres/src/backend/utils/adt/varlena.c:5721"
  - "postgres/src/backend/utils/adt/varlena.c:5756"
reproduced: false
---

# `invalid Unicode code point: %04X`

## What it means

A function was asked to produce a character from a numeric code point that is not a valid Unicode scalar value. Valid code points fall within a defined range and exclude the surrogate block, and the supplied value fell outside that.

## When it happens

Calling `chr()` on an out-of-range integer, or using a Unicode escape (`\u` / `\U`, or `U&'...'` with `UESCAPE`) whose numeric value names a surrogate or a code point beyond the Unicode maximum.

## How to fix

Pass a code point within the valid Unicode range and outside the surrogate block. For characters above the basic multilingual plane, ensure the database encoding is UTF-8, and check that any application-side computation of the code point is correct.

## Example

*Illustrative* — a code point past the Unicode maximum.

```sql
SELECT chr(16000000);  -- beyond the valid Unicode range
```

## Related

- [invalid unicode escape](./invalid-unicode-escape.md)
- [character number must be positive](./character-number-must-be-positive.md)
