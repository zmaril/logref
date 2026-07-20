---
message: "COPY delimiter must be a single one-byte character"
slug: copy-delimiter-must-be-a-single-one-byte-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:834"
reproduced: false
---

# `COPY delimiter must be a single one-byte character`

## What it means

A `COPY` delimiter was set to something other than a single one-byte character — an empty string, a multi-character string, or a multibyte character. The delimiter must be exactly one byte.

## When it happens

It happens on `COPY ... WITH (DELIMITER '...')` when the delimiter is not a single ASCII (one-byte) character.

## How to fix

Use a single one-byte delimiter such as `,`, a tab, or `|`. Multibyte or multi-character delimiters are not supported.

## Example

*Illustrative* — a multi-character delimiter.

```sql
COPY t TO STDOUT WITH (DELIMITER '::');
-- ERROR:  COPY delimiter must be a single one-byte character
```

## Related

- [COPY quote must be a single one-byte character](./copy-quote-must-be-a-single-one-byte-character.md)
- [COPY escape must be a single one-byte character](./copy-escape-must-be-a-single-one-byte-character.md)
