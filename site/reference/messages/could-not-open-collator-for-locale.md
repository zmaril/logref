---
message: "could not open collator for locale \"%s\": %s"
slug: could-not-open-collator-for-locale
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:493"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:511"
reproduced: false
---

# `could not open collator for locale "%s": %s`

## What it means

The server could not open an ICU collator for a locale. The first `%s` is the locale and the second is the ICU error. Without a collator, string comparison for that collation cannot proceed.

## When it happens

A collation or database references an ICU locale the installed ICU library cannot open — a malformed tag, or a locale missing from the ICU build. It fires when the collation is first used or validated.

## How to fix

Use an ICU locale the installed library supports, and verify the ICU version matches what the collation was created against. Recreate the collation with a valid locale if the string is malformed.

## Example

*Illustrative* — an unsupported ICU locale.

```text
ERROR:  could not open collator for locale "xx-bogus": U_ILLEGAL_ARGUMENT_ERROR
```

## Related

- [could not get language from locale](./could-not-get-language-from-locale.md)
- [failed to restore old locale](./failed-to-restore-old-locale-a227b9.md)
