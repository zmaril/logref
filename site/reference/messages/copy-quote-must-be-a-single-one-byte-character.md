---
message: "COPY quote must be a single one-byte character"
slug: copy-quote-must-be-a-single-one-byte-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:898"
reproduced: false
---

# `COPY quote must be a single one-byte character`

## What it means

A CSV `COPY` quote character was set to something other than a single one-byte character. The quote must be exactly one byte.

## When it happens

It happens on `COPY ... WITH (FORMAT csv, QUOTE '...')` when the quote is empty, multiple characters, or multibyte.

## How to fix

Use a single one-byte quote character, typically `"`. Multibyte or multi-character quote values are not supported.

## Example

*Illustrative* — a multi-character quote.

```sql
COPY t TO STDOUT WITH (FORMAT csv, QUOTE '""');
-- ERROR:  COPY quote must be a single one-byte character
```

## Related

- [COPY delimiter must be a single one-byte character](./copy-delimiter-must-be-a-single-one-byte-character.md)
- [COPY escape must be a single one-byte character](./copy-escape-must-be-a-single-one-byte-character.md)
