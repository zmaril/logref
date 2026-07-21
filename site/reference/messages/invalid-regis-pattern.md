---
message: "invalid regis pattern: \"%s\""
slug: invalid-regis-pattern
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/tsearch/regis.c:118"
  - "postgres/src/backend/tsearch/regis.c:133"
  - "postgres/src/backend/tsearch/regis.c:142"
  - "postgres/src/backend/tsearch/regis.c:150"
reproduced: false
---

# `invalid regis pattern: "%s"`

## What it means

Internal error. The text-search `regis` matcher (a small pattern engine used for affix conditions in dictionaries) was handed a pattern it cannot compile. The placeholder is the pattern. `regis` handles a restricted pattern syntax; an out-of-range pattern trips this guard.

## When it happens

Loading a text-search dictionary whose affix conditions produce a `regis` pattern the engine rejects — typically a malformed or unsupported affix condition, or corrupted dictionary data.

## How to fix

Treat it as a dictionary-data problem. Check the affix file's condition patterns for the affected dictionary and ensure the dictionary/affix files are a valid, matching set. If the files are from a third party, report the malformed pattern to their source.

## Example

*Illustrative* — emitted internally loading a dictionary.

```text
ERROR:  invalid regis pattern: "[a-"
```

## Related

- [invalid affix flag](./invalid-affix-flag.md)
- [invalid affix alias](./invalid-affix-alias.md)
