---
message: "could not convert locale name \"%s\" to language tag: %s"
slug: could-not-convert-locale-name-to-language-tag
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1769"
  - "postgres/src/bin/initdb/initdb.c:2385"
reproduced: false
---

# `could not convert locale name "%s" to language tag: %s`

## What it means

Postgres or `initdb` could not turn a given locale name into an ICU/BCP 47 language tag. The placeholders are the locale name and the underlying reason. The locale string is not one the conversion routine recognizes.

## When it happens

Creating a database, collation, or cluster with an ICU locale name that is malformed or not understood, or running `initdb` with an unsupported locale argument.

## How to fix

Use a valid locale name for the provider — a BCP 47 tag such as `en-US` for ICU, or a system locale the platform supports. Check the available locales and the ICU version, and correct the locale argument to a recognized form.

## Example

*Illustrative* — an unrecognized locale name.

```text
FATAL:  could not convert locale name "wibble" to language tag: U_ILLEGAL_ARGUMENT_ERROR
```

## Related

- [collation failed](./collation-failed.md)
- [could not convert string to UTF-16 error code](./could-not-convert-string-to-utf-16-error-code.md)
