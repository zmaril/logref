---
message: "COPY file signature not recognized"
slug: copy-file-signature-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:202"
reproduced: false
---

# `COPY file signature not recognized`

## What it means

A binary-format `COPY FROM` read a file whose leading signature bytes do not match the expected PostgreSQL binary-copy header. The input is not a valid binary COPY file.

## When it happens

It happens on `COPY ... FROM ... WITH (FORMAT binary)` when the file is text/CSV, truncated, or produced by an incompatible tool.

## How to fix

Confirm the file was produced by `COPY ... TO ... (FORMAT binary)`. If it is text or CSV, use the matching format instead of `binary`. Regenerate the file with the correct binary export if needed.

## Example

*Illustrative* — a non-binary file loaded as binary.

```sql
COPY t FROM '/tmp/data.csv' WITH (FORMAT binary);
-- ERROR:  COPY file signature not recognized
```

## Related

- [COPY format not recognized](./copy-format-not-recognized.md)
- [column name mismatch in header line field got expected](./column-name-mismatch-in-header-line-field-got-expected.md)
