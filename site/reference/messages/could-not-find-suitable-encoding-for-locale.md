---
message: "could not find suitable encoding for locale \"%s\""
slug: could-not-find-suitable-encoding-for-locale
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2762"
reproduced: false
---

# `could not find suitable encoding for locale "%s"`

## What it means

`initdb` inspected the locale you asked for and could not map it to a server encoding it supports. Every database has a single server encoding, and `initdb` derives a default from the locale when you do not name one explicitly.

## When it happens

It happens during `initdb` (directly or via `pg_upgrade`/packaging scripts) when the chosen `LC_CTYPE` implies an encoding Postgres will not use as a server encoding — for example a locale that maps to a client-only encoding.

## How to fix

Pass an explicit encoding that pairs with your locale, for example `initdb --locale=... --encoding=UTF8`, or choose a locale whose codeset Postgres supports as a server encoding. `UTF8` works with essentially every locale and is the usual choice.

## Example

*Illustrative* — a locale with no usable server encoding.

```text
initdb: error: could not find suitable encoding for locale "ja_JP.SJIS"
```

## Related

- [could not load locale](./could-not-load-locale.md)
- [could not get collation version for locale error code](./could-not-get-collation-version-for-locale-error-code.md)
