---
message: "storage \"%s\" not recognized"
slug: storage-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:454"
  - "postgres/src/backend/commands/typecmds.c:4392"
reproduced: false
---

# `storage "%s" not recognized`

## What it means

A column storage mode was specified that is not one of the recognized values. The placeholder is the given mode. Valid storage modes are `PLAIN`, `EXTERNAL`, `EXTENDED`, and `MAIN`.

## When it happens

It arises from `ALTER TABLE ... ALTER COLUMN ... SET STORAGE mode` (or `CREATE TABLE` column options) with a misspelled or invalid mode.

## How to fix

Use one of `PLAIN`, `EXTERNAL`, `EXTENDED`, or `MAIN`. Choose based on TOAST behavior: `EXTENDED` (compress and out-of-line) is the default for TOASTable types; `PLAIN` keeps values inline uncompressed.

## Example

*Illustrative* — an unrecognized storage mode.

```text
ERROR:  storage "COMPRESSED" not recognized
```

## Related

- [option "%s" not found](./option-not-found.md)
- [type modifier cannot be specified for shell type "%s"](./type-modifier-cannot-be-specified-for-shell-type.md)
