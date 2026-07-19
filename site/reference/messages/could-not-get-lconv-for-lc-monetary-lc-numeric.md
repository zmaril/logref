---
message: "could not get lconv for LC_MONETARY = \"%s\", LC_NUMERIC = \"%s\": %m"
slug: could-not-get-lconv-for-lc-monetary-lc-numeric
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:532"
reproduced: false
---

# `could not get lconv for LC_MONETARY = "%s", LC_NUMERIC = "%s": %m`

## What it means

The server tried to read the locale's numeric and monetary formatting rules and the C library call failed. The `%m` reason gives the cause. These rules define the decimal point, thousands separator, and currency symbol.

## When it happens

It fires while caching locale formatting information, when `localeconv` fails under the configured `LC_MONETARY`/`LC_NUMERIC` — usually a locale that is set but not installed on the host.

## How to fix

Make sure the locales named by `lc_monetary` and `lc_numeric` are installed on the operating system (for example via the system's locale package), or set them to a locale that is present. Restart or reload after fixing the locale configuration.

## Example

*Illustrative* — formatting rules could not be read for the locale.

```text
ERROR:  could not get lconv for LC_MONETARY = "de_DE.UTF-8", LC_NUMERIC = "de_DE.UTF-8": Success
```

## Related

- [could not load locale](./could-not-load-locale.md)
- [could not initialize gmt time zone](./could-not-initialize-gmt-time-zone.md)
