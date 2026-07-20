---
message: "column name mismatch in header line field %d: got null value (\"%s\"), expected \"%s\""
slug: column-name-mismatch-in-header-line-field-got-null-value-expected
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:832"
reproduced: false
---

# `column name mismatch in header line field %d: got null value ("%s"), expected "%s"`

## What it means

A `COPY ... WITH (HEADER MATCH)` found a null (empty, unquoted) value in the header row where it expected a specific column name. A matched header must name every column, so a null header field is an error.

## When it happens

It happens during `COPY FROM ... (HEADER match)` when a header field is empty rather than carrying the expected column name.

## How to fix

Provide the expected column name in that header position, or remove the stray empty field. Ensure the header row lists every target column by name.

## Example

*Illustrative* — an empty header field under HEADER MATCH.

```text
ERROR:  column name mismatch in header line field 2: got null value (""), expected "quantity"
```

## Related

- [column name mismatch in header line field got expected](./column-name-mismatch-in-header-line-field-got-expected.md)
- [COPY format not recognized](./copy-format-not-recognized.md)
