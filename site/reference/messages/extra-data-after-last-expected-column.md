---
message: "extra data after last expected column"
slug: extra-data-after-last-expected-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:977"
  - "postgres/src/backend/commands/copyfromparse.c:1844"
  - "postgres/src/backend/commands/copyfromparse.c:2100"
reproduced: false
---

# `extra data after last expected column`

## What it means

During a `COPY FROM`, a data line had more fields than the target column list. The row contains extra delimiter-separated values beyond the last expected column, so it cannot be mapped to the table.

## When it happens

`COPY` of a file whose rows have more columns than the table (or the specified column list), a wrong delimiter causing fields to split unexpectedly, or unquoted delimiter characters inside a value in CSV mode.

## How to fix

Make the file's columns match the target: fix the column count, specify the correct `DELIMITER`, and in CSV mode quote values that contain the delimiter. If the file has more columns than you want, list only the intended columns in `COPY table (col_list)` and pre-process the file to drop the extras. Check for a header row that should be skipped with `HEADER`.

## Example

*Illustrative* — a row with too many fields.

```text
ERROR:  extra data after last expected column
```

## Related

- [end-of-copy marker is not alone on its line](./end-of-copy-marker-is-not-alone-on-its-line.md)
- [column not referenced by COPY](./column-not-referenced-by-copy.md)
