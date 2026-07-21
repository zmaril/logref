---
message: "affix flag \"%s\" is out of range"
slug: affix-flag-is-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:386"
  - "postgres/src/backend/tsearch/spell.c:1055"
reproduced: false
---

# `affix flag "%s" is out of range`

## What it means

A spelling dictionary's affix file contained a flag value outside the permitted range. Affix flags label rules in the dictionary, and this flag exceeded the maximum the flag format allows. It is a configuration-file error.

## When it happens

Loading a text-search spelling dictionary (`ispell`-style) whose affix file uses a flag number too large for the configured flag representation, or a mismatched flag mode between the dictionary and its affix file.

## How to fix

Check the dictionary's affix and flag settings. Ensure the flag mode matches the affix file's format and that flag values stay within range, then reload the dictionary. Corrupt or mismatched dictionary files from an external source are a common cause.

## Example

*Illustrative* — an out-of-range affix flag.

```text
ERROR:  affix flag "70000" is out of range
```

## Related

- [multiple stopwords parameters](./multiple-stopwords-parameters.md)
- [invalid value for option](./invalid-value-for-option.md)
