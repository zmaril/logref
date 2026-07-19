---
message: "could not open collator for locale \"%s\" with rules \"%s\": %s"
slug: could-not-open-collator-for-locale-with-rules
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:609"
reproduced: false
---

# `could not open collator for locale "%s" with rules "%s": %s`

## What it means

The ICU locale support tried to build a collator for a locale using custom tailoring rules and ICU reported failure. The `%s` values give the locale, the rules, and the ICU error. The collator defines sort order.

## When it happens

It fires while creating or opening an ICU collation defined with custom `rules`, when ICU rejects the locale or the rule string — usually a syntax error in the rules or an invalid locale name.

## How to fix

Check the collation's `rules` for valid ICU tailoring syntax and use a locale name ICU recognizes. Correcting the rule string (or the locale) in the `CREATE COLLATION` definition resolves it.

## Example

*Illustrative* — invalid ICU tailoring rules.

```text
ERROR:  could not open collator for locale "und" with rules "&a <<< b <": U_INVALID_FORMAT_ERROR
```

## Related

- [could not open casemap for locale](./could-not-open-casemap-for-locale.md)
- [could not open ICU converter for encoding](./could-not-open-icu-converter-for-encoding.md)
