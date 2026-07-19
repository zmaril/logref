---
message: "could not load locale \"%s\""
slug: could-not-load-locale
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1035"
reproduced: false
---

# `could not load locale "%s"`

## What it means

The server tried to activate a named locale and the C library would not load it. Locales govern character classification, case rules, and sort order, and this one could not be made active.

## When it happens

It fires when resolving a collation or setting locale-dependent behavior, when the requested locale is set but not installed on the operating system.

## How to fix

Install the locale on the host (for example generate it with the system's locale tooling), or use a locale that is already present. After installing the locale, the collation or setting that referenced it works.

## Example

*Illustrative* — a locale that is not installed on the host.

```text
ERROR:  could not load locale "de_DE.utf8"
```

## Related

- [could not find suitable encoding for locale](./could-not-find-suitable-encoding-for-locale.md)
- [could not get collation version for locale error code](./could-not-get-collation-version-for-locale-error-code.md)
