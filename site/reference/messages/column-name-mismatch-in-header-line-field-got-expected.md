---
message: "column name mismatch in header line field %d: got \"%s\", expected \"%s\""
slug: column-name-mismatch-in-header-line-field-got-expected
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:839"
reproduced: false
---

# `column name mismatch in header line field %d: got "%s", expected "%s"`

## What it means

A `COPY ... WITH (HEADER MATCH)` read a header row whose column name in a given position did not match the name Postgres expected for that position. With `HEADER MATCH`, the header must line up exactly with the target columns.

## When it happens

It happens during `COPY FROM ... (FORMAT csv, HEADER match)` when the input file's header names, in order, differ from the columns being loaded.

## How to fix

Fix the header row in the input file so its names and order match the target column list, or load with plain `HEADER true` (which only skips the header) if you do not need strict matching.

## Example

*Illustrative* — a header name that does not match.

```text
ERROR:  column name mismatch in header line field 2: got "qty", expected "quantity"
```

## Related

- [column name mismatch in header line field got null value](./column-name-mismatch-in-header-line-field-got-null-value-expected.md)
- [COPY file signature not recognized](./copy-file-signature-not-recognized.md)
