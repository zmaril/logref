---
message: "could not open ICU converter for encoding \"%s\": %s"
slug: could-not-open-icu-converter-for-encoding
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:1210"
reproduced: false
---

# `could not open ICU converter for encoding "%s": %s`

## What it means

ICU locale support tried to open a character-set converter for a database encoding and ICU reported failure. The `%s` values give the encoding and the ICU error. The converter translates between the database encoding and ICU's internal form.

## When it happens

It fires while using an ICU collation in a database whose encoding ICU cannot convert, when opening the converter fails — usually an encoding the installed ICU build does not support.

## How to fix

Use a database encoding the linked ICU supports (UTF-8 is the safest choice for ICU collations), or rebuild against an ICU that provides the converter. Aligning the encoding with ICU's capabilities resolves it.

## Example

*Illustrative* — ICU could not open a converter for the encoding.

```text
ERROR:  could not open ICU converter for encoding "SQL_ASCII": U_FILE_ACCESS_ERROR
```

## Related

- [could not open casemap for locale](./could-not-open-casemap-for-locale.md)
- [could not open collator for locale with rules](./could-not-open-collator-for-locale-with-rules.md)
