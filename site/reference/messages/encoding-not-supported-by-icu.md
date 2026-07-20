---
message: "encoding \"%s\" not supported by ICU"
slug: encoding-not-supported-by-icu
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:1202"
reproduced: false
---

# `encoding "%s" not supported by ICU`

## What it means

A database or collation using the ICU provider requested an encoding that the ICU library does not handle. The placeholder is the encoding name. ICU supports many but not all PostgreSQL encodings.

## When it happens

It fires when creating or using an ICU-based collation or database whose server encoding ICU cannot process.

## How to fix

Use `UTF8` (the recommended encoding with ICU) or another encoding ICU supports, or switch that collation to the `libc` provider if you must keep the current encoding. Check the ICU documentation for supported converters.

## Example

*Illustrative* — an ICU-unsupported encoding.

```text
ERROR:  encoding "MULE_INTERNAL" not supported by ICU
```

## Related

- [encoding does not match locale](./encoding-does-not-match-locale.md)
- [destination encoding does not exist](./destination-encoding-does-not-exist.md)
