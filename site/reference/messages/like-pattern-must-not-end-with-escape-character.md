---
message: "LIKE pattern must not end with escape character"
slug: like-pattern-must-not-end-with-escape-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ESCAPE_SEQUENCE
    code: "22025"
call_sites:
  - "postgres/src/backend/utils/adt/like_match.c:166"
  - "postgres/src/backend/utils/adt/like_match.c:234"
  - "postgres/src/backend/utils/adt/like_match.c:354"
reproduced: false
---

# `LIKE pattern must not end with escape character`

## What it means

A `LIKE` or `SIMILAR TO` pattern ended with its escape character, leaving nothing for the escape to apply to. The escape character must be followed by the character it escapes, so a trailing escape is incomplete.

## When it happens

Writing a pattern that ends in the escape character — the default backslash, or whatever the `ESCAPE` clause sets — often because a value was concatenated onto the pattern and happened to end in the escape, or the escape was doubled incorrectly.

## How to fix

Complete or remove the trailing escape. To match a literal escape character at the end, double it (for the default, `\\`) or choose a different `ESCAPE` character. If the pattern is built from user input, escape that input consistently before appending it.

## Example

*Illustrative* — a pattern ending in the escape character.

```sql
SELECT 'abc' LIKE 'ab\';  -- trailing escape has nothing to escape
```

## Related

- [invalid escape string](./invalid-escape-string.md)
- [like pattern must not end with escape character](./like-pattern-must-not-end-with-escape-character.md)
