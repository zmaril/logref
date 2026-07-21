---
message: "COPY escape must be a single one-byte character"
slug: copy-escape-must-be-a-single-one-byte-character
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:915"
reproduced: false
---

# `COPY escape must be a single one-byte character`

## What it means

A CSV `COPY` escape character was set to something other than a single one-byte character. The escape must be exactly one byte.

## When it happens

It happens on `COPY ... WITH (FORMAT csv, ESCAPE '...')` when the escape is empty, multiple characters, or multibyte.

## How to fix

Use a single one-byte escape character, commonly the same as the quote (`"`) or a backslash. Do not use multibyte or multi-character values.

## Example

*Illustrative* — a multi-character escape.

```sql
COPY t FROM STDIN WITH (FORMAT csv, ESCAPE '\\\\');
-- ERROR:  COPY escape must be a single one-byte character
```

## Related

- [COPY quote must be a single one-byte character](./copy-quote-must-be-a-single-one-byte-character.md)
- [COPY delimiter must be a single one-byte character](./copy-delimiter-must-be-a-single-one-byte-character.md)
