---
message: "could not convert string to UTF-8: error code %lu"
slug: could-not-convert-string-to-utf-8-error-code
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:661"
reproduced: false
---

# `could not convert string to UTF-8: error code %lu`

## What it means

PostgreSQL could not convert a string from the platform's wide-character encoding to UTF-8 during localized message handling. The `%lu` is the OS error code. This is an internal localization step.

## When it happens

It happens on Windows during message localization when the wide-character to UTF-8 conversion fails, usually from a broken locale or an unexpected byte sequence.

## How to fix

This is an internal localization failure. Confirm the server's locale and `lc_messages` settings are valid on the host. If it recurs, note the active locale and report a reproducible case.

## Example

*Illustrative* — a string that fails UTF-8 conversion.

```text
ERROR:  could not convert string to UTF-8: error code 1113
```

## Related

- [could not convert format string from UTF-8: error code](./could-not-convert-format-string-from-utf-8-error-code.md)
- [could not create locale](./could-not-create-locale.md)
