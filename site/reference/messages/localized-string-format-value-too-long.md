---
message: "localized string format value too long"
slug: localized-string-format-value-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:2669"
  - "postgres/src/backend/utils/adt/formatting.c:2689"
  - "postgres/src/backend/utils/adt/formatting.c:2709"
  - "postgres/src/backend/utils/adt/formatting.c:2729"
  - "postgres/src/backend/utils/adt/formatting.c:2748"
  - "postgres/src/backend/utils/adt/formatting.c:2767"
  - "postgres/src/backend/utils/adt/formatting.c:2791"
  - "postgres/src/backend/utils/adt/formatting.c:2809"
  - "postgres/src/backend/utils/adt/formatting.c:2827"
  - "postgres/src/backend/utils/adt/formatting.c:2845"
  - "postgres/src/backend/utils/adt/formatting.c:2862"
  - "postgres/src/backend/utils/adt/formatting.c:2879"
reproduced: false
---

# `localized string format value too long`

## What it means

While formatting a date/time with a localized pattern (`to_char` with locale-dependent fields like month or day names), the produced string exceeded the internal buffer. Some locales have very long month/day names, and a format that repeats them can overflow the fixed output size.

## When it happens

`to_char(timestamp, fmt)` with locale-sensitive fields (`TMMonth`, `TMDay`) under a locale whose translated names are long, especially in formats that emit several such fields. It depends on `lc_time` and the specific pattern.

## How to fix

Shorten the format or reduce the number of locale-dependent fields, or use non-localized field forms. If you need the localized names, format fewer of them per call or post-process. Switching `lc_time` to a locale with shorter names also avoids it, though that changes the output language.

## Example

*Illustrative* — a long localized format under a verbose locale.

```sql
SELECT to_char(now(), 'TMMonth TMDay TMMonth TMDay ...');
```

Produces:

```text
ERROR:  localized string format value too long
```

## Related

- [timestamp out of range](./timestamp-out-of-range-2f12c7.md)
- [%s format is not recognized](./format-is-not-recognized.md)
