---
message: "encoding conversion from %s to ASCII not supported"
slug: encoding-conversion-from-to-ascii-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/ascii.c:75"
reproduced: false
---

# `encoding conversion from %s to ASCII not supported`

## What it means

A conversion to ASCII was requested from an encoding for which PostgreSQL provides no such conversion. The placeholder is the source encoding. Not every encoding has an ASCII-conversion function.

## When it happens

It fires from `to_ascii()` (or a related path) when the source encoding is not one of the few that `to_ascii` supports.

## How to fix

`to_ascii` supports only a limited set of source encodings (such as `LATIN1`, `LATIN2`, `LATIN9`, and `WIN1250`). Convert through one of those first, or use `convert()`/`convert_to()` for general encoding conversion instead of `to_ascii`.

## Example

*Illustrative* — to_ascii from an unsupported encoding.

```sql
SELECT to_ascii('...', 'UTF8');
-- encoding conversion from UTF8 to ASCII not supported
```

## Related

- [encoding conversion to or from SQL_ASCII is not supported](./encoding-conversion-to-or-from-sql-ascii-is-not-supported.md)
- [default conversion function for encoding to does not exist](./default-conversion-function-for-encoding-to-does-not-exist.md)
