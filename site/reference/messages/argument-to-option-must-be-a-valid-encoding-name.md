---
message: "argument to option \"%s\" must be a valid encoding name"
slug: argument-to-option-must-be-a-valid-encoding-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:743"
reproduced: false
---

# `argument to option "%s" must be a valid encoding name`

## What it means

An option that expects a character-encoding name was given a value that is not a recognized encoding.

## When it happens

It occurs in commands and functions that take an encoding option (for example `convert`, `CREATE DATABASE ... ENCODING`, or client-encoding-related settings) when the supplied name is misspelled or unsupported.

## How to fix

Use a valid encoding name such as `UTF8`, `LATIN1`, or `WIN1252`. Check the list of supported encodings in the documentation, correct the spelling, and confirm the encoding is available in your build.

## Example

*Illustrative* — an unknown encoding name.

```text
ERROR:  argument to option "encoding" must be a valid encoding name
```

## Related

- [array element type cannot be](./array-element-type-cannot-be.md)
- [affix file contains both old-style and new-style commands](./affix-file-contains-both-old-style-and-new-style-commands.md)
