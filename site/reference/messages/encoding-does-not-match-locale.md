---
message: "encoding \"%s\" does not match locale \"%s\""
slug: encoding-does-not-match-locale
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1711"
reproduced: false
---

# `encoding "%s" does not match locale "%s"`

## What it means

A collation or database setup paired an encoding with a locale that the operating system reports as incompatible. The placeholders are the encoding and locale names. The encoding must be one the locale can operate in.

## When it happens

It fires from `CREATE COLLATION`, `CREATE DATABASE`, or `initdb` when the requested encoding does not match the character set implied by the locale.

## How to fix

Pick an encoding the locale supports, or a locale that matches your encoding. For a UTF-8 database, use a `.UTF-8` locale. Consult the operating system's available locales (`locale -a`) and choose a consistent pair.

## Example

*Illustrative* — an encoding/locale mismatch.

```sql
CREATE DATABASE d ENCODING 'LATIN1' LC_CTYPE 'en_US.UTF-8' TEMPLATE template0;
-- encoding "LATIN1" does not match locale "en_US.UTF-8"
```

## Related

- [Encoding is not allowed as a server-side encoding](./encoding-is-not-allowed-as-a-server-side-encoding.md)
- [encoding not supported by ICU](./encoding-not-supported-by-icu.md)
