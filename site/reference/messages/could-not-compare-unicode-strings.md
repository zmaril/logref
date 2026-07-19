---
message: "could not compare Unicode strings: %m"
slug: could-not-compare-unicode-strings
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1143"
reproduced: false
---

# `could not compare Unicode strings: %m`

## What it means

The libc locale provider failed to compare two strings while sorting or matching text. The `%m` reason gives the OS error. This is a failure inside the C library's collation routine, not a problem with the query itself.

## When it happens

It happens during collation-aware comparison under the libc provider, when the underlying `wcscoll`-family call reports an error — usually from a broken or mismatched locale definition on the host.

## How to fix

Check that the locale used by the affected column or database is installed and valid on this host (`locale -a`). A locale that exists at initdb time but is later removed or corrupted produces this. Reinstall the locale, or move the data to a database using a valid collation.

## Example

*Illustrative* — a comparison failing under a broken locale.

```text
ERROR:  could not compare Unicode strings: Invalid or incomplete multibyte or wide character
```

## Related

- [could not create locale](./could-not-create-locale.md)
- [could not determine which collation to use for regular expression](./could-not-determine-which-collation-to-use-for-regular-expression.md)
