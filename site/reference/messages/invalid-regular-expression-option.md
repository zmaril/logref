---
message: "invalid regular expression option: \"%.*s\""
slug: invalid-regular-expression-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/regexp.c:443"
  - "postgres/src/backend/utils/adt/regexp.c:679"
reproduced: false
---

# `invalid regular expression option: "%.*s"`

## What it means

A regular-expression flag string contained a character that is not a recognized option. The placeholder shows the offending flag. Postgres accepts a fixed set of embedded and function-argument regex flags.

## When it happens

It arises from regex functions that take a flags argument — `regexp_replace`, `regexp_matches`, `regexp_count`, and relatives — or from embedded `(?flags)` in a pattern, when a flag letter is not valid.

## How to fix

Use only supported flag letters: for example `i` (case-insensitive), `g` (global, where accepted), `m`/`n` (newline-sensitive), `x` (expanded/whitespace-insensitive), `s`, `p`, `w`, `q`. Remove the unrecognized character from the flags string.

## Example

*Illustrative* — an unknown regex flag.

```sql
SELECT regexp_replace('a', 'a', 'b', 'z');  -- z is not a valid flag
```

## Related

- [invalid escape string](./invalid-escape-string.md)
- [invalid value for boolean option](./invalid-value-for-boolean-option.md)
