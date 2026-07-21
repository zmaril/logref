---
message: "literal carriage return found in data"
slug: literal-carriage-return-found-in-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:1656"
  - "postgres/src/backend/commands/copyfromparse.c:1673"
reproduced: false
---

# `literal carriage return found in data`

## What it means

During `COPY` in text/CSV format, a bare carriage return (`\r`) appeared in the data where it was not allowed. `COPY` is strict about newline conventions to avoid ambiguity.

## When it happens

It arises loading data whose line endings mix conventions — for example CRLF or lone-CR endings feeding a `COPY` expecting a consistent newline — so a `\r` shows up inside a data line.

## How to fix

Normalize the file's line endings before loading (convert to plain `\n`), or set the `COPY` newline handling to match the file. For CSV, make sure embedded carriage returns are inside quoted fields; for text format, remove stray `\r` characters.

## Example

*Illustrative* — a stray carriage return in COPY data.

```text
ERROR:  literal carriage return found in data
```

## Related

- [invalid hexadecimal digit](./invalid-hexadecimal-digit.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-6582cf.md)
