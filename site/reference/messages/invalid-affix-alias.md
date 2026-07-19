---
message: "invalid affix alias \"%s\""
slug: invalid-affix-alias
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:1180"
  - "postgres/src/backend/tsearch/spell.c:1192"
  - "postgres/src/backend/tsearch/spell.c:1756"
  - "postgres/src/backend/tsearch/spell.c:1761"
  - "postgres/src/backend/tsearch/spell.c:1766"
reproduced: false
---

# `invalid affix alias "%s"`

## What it means

A text-search dictionary (Ispell/Hunspell-style) referenced an affix alias that its affix file does not define. The placeholder is the alias. Affix aliases are numbered flag sets declared in the affix file; a reference to an undefined one is rejected while loading the dictionary.

## When it happens

Creating or loading a text-search dictionary whose dictionary (`.dict`) file uses an alias flag that the affix (`.affix`) file does not define, or whose affix file is mismatched with the dictionary file.

## How to fix

Make the affix and dictionary files a matching set: every alias used in the dictionary must be defined in the affix file (`AF` entries for the alias flag type). Fix the mismatched or corrupted dictionary files, then reload the text-search configuration.

## Example

*Illustrative* — an undefined affix alias.

```text
ERROR:  invalid affix alias "37"
```

## Related

- [invalid affix flag](./invalid-affix-flag.md)
- [invalid regis pattern](./invalid-regis-pattern.md)
