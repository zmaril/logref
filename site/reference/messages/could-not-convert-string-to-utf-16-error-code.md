---
message: "could not convert string to UTF-16: error code %lu"
slug: could-not-convert-string-to-utf-16-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1121"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1134"
reproduced: false
---

# `could not convert string to UTF-16: error code %lu`

## What it means

On Windows, Postgres could not convert a string to UTF-16 for a system API call. The placeholder is the OS error code. The conversion routine the platform provides rejected the input or failed internally.

## When it happens

Text handling on Windows that must cross into wide-character APIs — for example locale-aware comparison or filesystem calls — when the source encoding or a code point cannot be converted.

## How to fix

Check the string's encoding matches the database and client encodings, and look up the reported Windows error code for specifics. Ensure the data is valid for the server encoding, and verify the locale configuration on the Windows host. Isolate the offending value if it recurs.

## Example

*Illustrative* — a UTF-16 conversion failure on Windows.

```text
ERROR:  could not convert string to UTF-16: error code 1113
```

## Related

- [could not convert locale name to language tag](./could-not-convert-locale-name-to-language-tag.md)
- [could not determine which collation to use for string comparison](./could-not-determine-which-collation-to-use-for-string-comparison.md)
