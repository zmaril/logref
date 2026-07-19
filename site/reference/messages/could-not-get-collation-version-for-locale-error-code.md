---
message: "could not get collation version for locale \"%s\": error code %lu"
slug: could-not-get-collation-version-for-locale-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1060"
reproduced: false
---

# `could not get collation version for locale "%s": error code %lu`

## What it means

On Windows, the server asked the operating system for the version string of a locale's collation and the call failed. The `%lu` value is the Windows error code. Postgres records collation versions so it can warn when a sort order changes.

## When it happens

It fires while resolving a collation on Windows, when `GetNLSVersionEx` fails for the locale — usually a locale name the system does not recognize.

## How to fix

Confirm the collation's locale name is valid for the host operating system. If the locale is unknown to Windows, create or use a collation whose name the system accepts. Look up the reported Windows error code for the precise cause.

## Example

*Illustrative* — a locale whose collation version could not be read.

```text
ERROR:  could not get collation version for locale "xx-YY": error code 87
```

## Related

- [could not load locale](./could-not-load-locale.md)
- [could not find suitable encoding for locale](./could-not-find-suitable-encoding-for-locale.md)
