---
message: "invalid hexadecimal digit"
slug: invalid-hexadecimal-digit
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parser.c:336"
  - "postgres/src/backend/utils/adt/varlena.c:5627"
reproduced: false
---

# `invalid hexadecimal digit`

## What it means

A string that should contain only hexadecimal digits included a character that is not `0`-`9`, `a`-`f`, or `A`-`F`. Parsing of the hex value failed at that character.

## When it happens

It arises when converting text to bytea in hex format, decoding hex with `decode(..., 'hex')`, or parsing a hex literal, and the input has a stray non-hex character (including spaces in some contexts).

## How to fix

Make sure the input contains only hexadecimal digits, with no spaces, `0x` prefix, or punctuation. Strip separators before decoding. For `bytea` hex format, the string is a plain run of hex digits after the `\x` prefix.

## Example

*Illustrative* — a non-hex character in hex input.

```sql
SELECT decode('12zz', 'hex');  -- z is not a hex digit
```

## Related

- [invalid symbol found while decoding base32hex sequence](./invalid-symbol-found-while-decoding-base32hex-sequence.md)
- [invalid Unicode escape](./invalid-unicode-escape.md)
