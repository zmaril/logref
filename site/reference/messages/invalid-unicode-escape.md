---
message: "invalid Unicode escape"
slug: invalid-unicode-escape
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parser.c:492"
  - "postgres/src/backend/utils/adt/varlena.c:5785"
reproduced: false
---

# `invalid Unicode escape`

## What it means

A Unicode escape sequence was malformed. Postgres expects `\uXXXX` (four hex digits) or `\UXXXXXXXX` (eight hex digits), and the sequence found did not have the right number of hex digits.

## When it happens

It arises in string literals with Unicode escapes (`U&'...'`), in JSON/jsonb text with `\u` escapes, or in other contexts that accept Unicode escapes, when the digits are missing or non-hex.

## How to fix

Write Unicode escapes with the exact digit count: `\uXXXX` with four hex digits or `\UXXXXXXXX` with eight. For code points above U+FFFF, use the eight-digit form or a correct surrogate pair. Check for a truncated or mistyped escape.

## Example

*Illustrative* — a Unicode escape with too few digits.

```sql
SELECT U&'\00e';  -- needs four hex digits
```

## Related

- [invalid Unicode surrogate pair](./invalid-unicode-surrogate-pair.md)
- [invalid hexadecimal digit](./invalid-hexadecimal-digit.md)
