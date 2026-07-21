---
message: "affix file contains both old-style and new-style commands"
slug: affix-file-contains-both-old-style-and-new-style-commands
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:1568"
reproduced: false
---

# `affix file contains both old-style and new-style commands`

## What it means

A text-search dictionary's affix file mixed the old and new command syntaxes, which the ispell affix parser does not allow in a single file.

## When it happens

It occurs when loading an Ispell-style dictionary (via `CREATE TEXT SEARCH DICTIONARY` with an affix file) whose affix file combines legacy and modern command formats.

## How to fix

Edit the affix file to use one command style consistently — convert the old-style commands to the new style, or vice versa. Obtain the dictionary files from a consistent source, since mixing formats is not supported.

## Example

*Illustrative* — an affix file mixing command styles.

```text
ERROR:  affix file contains both old-style and new-style commands
```

## Related

- [argument to option must be a valid encoding name](./argument-to-option-must-be-a-valid-encoding-name.md)
- [alignment not recognized](./alignment-not-recognized.md)
