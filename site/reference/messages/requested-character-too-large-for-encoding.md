---
message: "requested character too large for encoding: %u"
slug: requested-character-too-large-for-encoding
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/oracle_compat.c:1065"
  - "postgres/src/backend/utils/adt/oracle_compat.c:1118"
reproduced: false
---

# `requested character too large for encoding: %u`

## What it means

A request to build a character from a code point produced a value that does not fit the target encoding. The placeholder is the code point. The chosen encoding cannot represent a character that large.

## When it happens

It arises from functions like `chr()` when the numeric argument exceeds what the database or the target encoding allows — for example an out-of-range code point for a single-byte encoding, or beyond the Unicode maximum in UTF-8.

## How to fix

Pass a code point within the encoding's valid range. For UTF-8, keep it within the Unicode range; for single-byte encodings, within that encoding's limited set. If you need broader characters, use a UTF-8 database.

## Example

*Illustrative* — chr() with an out-of-range code point.

```text
ERROR:  requested character too large for encoding: 1114112
```

## Related

- [unexpected encoding ID %d for ISO 8859 character sets](./unexpected-encoding-id-for-iso-8859-character-sets.md)
- [string is too long for tsvector (%d bytes, max %d bytes)](./string-is-too-long-for-tsvector-bytes-max-bytes.md)
