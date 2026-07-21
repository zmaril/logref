---
message: "invalid locale name \"%s\" for builtin provider"
slug: invalid-locale-name-for-builtin-provider
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1677"
  - "postgres/src/backend/utils/adt/pg_locale.c:1704"
  - "postgres/src/backend/utils/adt/pg_locale_builtin.c:336"
  - "postgres/src/bin/initdb/initdb.c:2514"
reproduced: false
---

# `invalid locale name "%s" for builtin provider`

## What it means

A collation/locale using the built-in provider was given a locale name the built-in provider does not offer. The placeholder is the locale name. The built-in collation provider supports only a small fixed set of locales (`C`, and `C.UTF-8`), not arbitrary names.

## When it happens

Creating a collation or database with `provider = builtin` and a locale other than the supported ones, or initializing a cluster whose built-in locale is set to an unsupported name.

## How to fix

Use a locale the built-in provider supports (`C` or `C.UTF-8`). For richer locale behavior, choose a different provider — `icu` with an ICU locale, or `libc` with an installed system locale — instead of `builtin`.

## Example

*Illustrative* — an unsupported builtin locale.

```sql
CREATE COLLATION c (provider = builtin, locale = 'en_US');
```

## Related

- [invalid collation](./invalid-collation.md)
- [could not determine which collation to use for function](./could-not-determine-which-collation-to-use-for-function.md)
