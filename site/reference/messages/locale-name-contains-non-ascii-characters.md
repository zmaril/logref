---
message: "locale name \"%s\" contains non-ASCII characters"
slug: locale-name-contains-non-ascii-characters
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL, WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:283"
  - "postgres/src/backend/utils/adt/pg_locale.c:315"
  - "postgres/src/bin/initdb/initdb.c:2238"
  - "postgres/src/bin/initdb/initdb.c:2284"
reproduced: false
---

# `locale name "%s" contains non-ASCII characters`

## What it means

A locale name given to the server or a client tool contains bytes outside the plain ASCII range. Locale names are used to look up operating-system locale definitions, and Postgres restricts them to ASCII so the same name resolves identically regardless of the current encoding.

## When it happens

Passing a locale (for `LC_COLLATE`, `LC_CTYPE`, `--locale`, or a `CREATE DATABASE ... LOCALE` clause) whose text includes accented or non-Latin characters — usually a copy-paste from a localized system tool, or a locale name that legitimately is not plain ASCII on that platform.

## How to fix

Use the ASCII spelling of the locale. List the names the OS actually offers (`locale -a` on Unix) and pick the exact ASCII identifier — for example `de_DE.UTF-8`, not a form carrying accented letters. If no ASCII name exists for the collation you need, use the ICU provider (`LOCALE_PROVIDER icu`) and an ICU locale name instead.

## Example

*Illustrative* — a non-ASCII locale name rejected at database creation.

```sql
CREATE DATABASE d LOCALE 'français';  -- use an ASCII locale name
```

## Related

- [could not create locale](./could-not-create-locale.md)
- [invalid locale name](./invalid-locale-name.md)
