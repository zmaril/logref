---
message: "unrecognized encoding: \"%s\""
slug: unrecognized-encoding-6df687
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/encode.c:65"
  - "postgres/src/backend/utils/adt/encode.c:115"
reproduced: false
---

# `unrecognized encoding: "%s"`

## What it means

A statement or setting named a character-set encoding that PostgreSQL does not recognize, so it could not map the name to a known encoding.

## When it happens

It arises from `CREATE DATABASE ... ENCODING`, `SET client_encoding`, `convert()`/`convert_to()`, and similar calls when the encoding name is misspelled or unsupported.

## How to fix

Use a supported encoding name — `SELECT * FROM pg_catalog.pg_encoding_to_char(i)` and the documentation list the valid ones. Common cases are writing `UTF-8` where `UTF8` is required, or a locale name where an encoding name is expected.

## Example

*Illustrative* — an unknown encoding name.

```text
ERROR:  unrecognized encoding: "UTF-9"
```

## Related

- [unrecognized locale provider: %s](./unrecognized-locale-provider-f222bb.md)
- [unrecognized origin value: "%s"](./unrecognized-origin-value.md)
