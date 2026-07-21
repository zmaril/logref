---
message: "unexpected default marker in COPY data"
slug: unexpected-default-marker-in-copy-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:2036"
  - "postgres/src/backend/commands/copyfromparse.c:2251"
reproduced: false
---

# `unexpected default marker in COPY data`

## What it means

A `COPY ... FROM` input stream contained a DEFAULT marker where one is not allowed. `COPY` supports a configurable DEFAULT string only under specific conditions; encountering it outside those conditions is an error.

## When it happens

It arises during `COPY FROM` when the data contains the DEFAULT token but the copy was not set up to accept it (the `DEFAULT` option was not given), or the marker appears for a column where defaults cannot apply.

## How to fix

Set the `DEFAULT 'marker'` option on the `COPY` if you intend to use default markers, and ensure the marker only appears for columns that have a usable default. Otherwise, remove the DEFAULT tokens from the input data.

## Example

*Illustrative* — a DEFAULT marker in COPY input without the option set.

```text
ERROR:  unexpected default marker in COPY data
```

## Related

- [program "%s" failed](./program-failed.md)
- [too few arguments for format()](./too-few-arguments-for-format.md)
