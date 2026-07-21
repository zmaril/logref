---
message: "invalid escape string"
slug: invalid-escape-string
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ESCAPE_SEQUENCE
    code: "22025"
call_sites:
  - "postgres/src/backend/utils/adt/like_match.c:450"
  - "postgres/src/backend/utils/adt/regexp.c:802"
reproduced: true
---

# `invalid escape string`

## What it means

An `ESCAPE` clause supplied to `LIKE`/`SIMILAR TO` (or a related pattern operation) was not a single-character string. The escape must be exactly one character, or empty to disable escaping.

## When it happens

It arises in a `LIKE ... ESCAPE 'xy'` or `SIMILAR TO ... ESCAPE '..'` clause when the escape string is longer than one character.

## How to fix

Give `ESCAPE` a single character, such as `ESCAPE '\'`, or an empty string `ESCAPE ''` to turn escaping off. If you need to match a literal backslash or the escape character itself, keep the escape one character and double it in the pattern.

## Example

*Reproduced* — captured from `reproducers/scenarios/17_strings_format_regex.sql`.

```sql
SELECT 'a' LIKE 'a' ESCAPE 'aa';
```

Produces:

```text
ERROR:  invalid escape string
```

## Related

- [invalid Unicode escape](./invalid-unicode-escape.md)
- [invalid regular expression option](./invalid-regular-expression-option.md)
