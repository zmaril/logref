---
message: "invalid affix flag \"%s\""
slug: invalid-affix-flag
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:382"
  - "postgres/src/backend/tsearch/spell.c:399"
  - "postgres/src/backend/tsearch/spell.c:408"
  - "postgres/src/backend/tsearch/spell.c:1051"
reproduced: false
---

# `invalid affix flag "%s"`

## What it means

A text-search dictionary's affix file used a flag value that is not valid for its declared flag format. The placeholder is the flag. Ispell/Hunspell affix files declare a flag encoding (ASCII, long, numeric), and flags must conform to it.

## When it happens

Loading a text-search dictionary whose affix file contains a flag inconsistent with its `FLAG` declaration, or a corrupted/mismatched affix file.

## How to fix

Correct the affix file so every flag matches the declared flag format, or fix the `FLAG` declaration to match the flags in use. Ensure the dictionary and affix files are a matching, uncorrupted set, then reload the text-search configuration.

## Example

*Illustrative* — a malformed affix flag.

```text
ERROR:  invalid affix flag "1a"
```

## Related

- [invalid affix alias](./invalid-affix-alias.md)
- [invalid regis pattern](./invalid-regis-pattern.md)
