---
message: "could not open casemap for locale \"%s\": %s"
slug: could-not-open-casemap-for-locale
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:541"
reproduced: false
---

# `could not open casemap for locale "%s": %s`

## What it means

The ICU locale support tried to open the case-mapping data for a locale and ICU reported failure. The `%s` values give the locale and the ICU error. Case mapping drives `lower()`, `upper()`, and case-insensitive behavior for ICU locales.

## When it happens

It fires while resolving or using an ICU-based collation, when ICU cannot open case-mapping data for the locale — usually an invalid locale name or an ICU build lacking that data.

## How to fix

Use a locale name the installed ICU recognizes, and confirm the ICU library the server links against provides the needed data. Correcting the collation's locale (or rebuilding against a complete ICU) resolves it.

## Example

*Illustrative* — ICU case-mapping data could not be opened.

```text
ERROR:  could not open casemap for locale "xx": U_FILE_ACCESS_ERROR
```

## Related

- [could not open collator for locale with rules](./could-not-open-collator-for-locale-with-rules.md)
- [could not open ICU converter for encoding](./could-not-open-icu-converter-for-encoding.md)
