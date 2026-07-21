---
message: "invalid Unicode surrogate pair"
slug: invalid-unicode-surrogate-pair
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parser.c:521"
  - "postgres/src/backend/utils/adt/varlena.c:5810"
reproduced: false
---

# `invalid Unicode surrogate pair`

## What it means

A Unicode surrogate code point appeared without its matching partner, or in the wrong order. Code points in the surrogate range must come in a valid high-then-low pair to encode a character above U+FFFF.

## When it happens

It arises in `U&'...'` string literals or JSON `\u` escapes when a high surrogate is not followed by a low surrogate (or vice versa), so the pair does not form a valid character.

## How to fix

Supply both halves of the surrogate pair in order (a high surrogate `\uD800`-`\uDBFF` followed by a low surrogate `\uDC00`-`\uDFFF`), or use the eight-digit `\U` form to write the code point directly. Do not emit lone surrogates.

## Example

*Illustrative* — a lone high surrogate.

```sql
SELECT E'\uD800';  -- unpaired surrogate
```

## Related

- [invalid Unicode escape](./invalid-unicode-escape.md)
- [invalid hexadecimal digit](./invalid-hexadecimal-digit.md)
