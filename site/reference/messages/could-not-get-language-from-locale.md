---
message: "could not get language from locale \"%s\": %s"
slug: could-not-get-language-from-locale
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:453"
  - "postgres/src/bin/initdb/initdb.c:2414"
reproduced: false
---

# `could not get language from locale "%s": %s`

## What it means

The server or `initdb` could not derive a language from a locale name while setting up ICU collation. The `%s` values are the locale and the ICU error text. The locale string could not be resolved to a known language.

## When it happens

A malformed or unrecognized ICU locale was passed to `CREATE COLLATION`, a database's ICU locale, or `initdb --icu-locale`. It also fires when the ICU build lacks data for the requested locale.

## How to fix

Use a valid ICU locale (a BCP 47 language tag such as `en-US` or `fr-CA`). List what your ICU build supports and correct the locale string in the failing command or in `initdb`.

## Example

*Illustrative* — a malformed ICU locale in CREATE COLLATION.

```text
ERROR:  could not get language from locale "xx-bogus": U_ILLEGAL_ARGUMENT_ERROR
```

## Related

- [could not open collator for locale](./could-not-open-collator-for-locale.md)
- [encoding mismatch](./encoding-mismatch.md)
