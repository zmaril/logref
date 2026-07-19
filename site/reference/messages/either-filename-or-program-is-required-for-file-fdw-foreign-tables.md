---
message: "either filename or program is required for file_fdw foreign tables"
slug: either-filename-or-program-is-required-for-file-fdw-foreign-tables
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FDW_DYNAMIC_PARAMETER_VALUE_NEEDED
    code: "HV002"
call_sites:
  - "postgres/contrib/file_fdw/file_fdw.c:348"
  - "postgres/contrib/file_fdw/file_fdw.c:436"
reproduced: false
---

# `either filename or program is required for file_fdw foreign tables`

## What it means

A `file_fdw` foreign table was defined without a data source. Each `file_fdw` table needs exactly one of the `filename` or `program` options to know where its data comes from.

## When it happens

Creating or altering a `file_fdw` foreign table (or its server/wrapper defaults) so that neither `filename` nor `program` is set.

## How to fix

Add a `filename` option pointing at the data file, or a `program` option that emits the data, to the foreign table's `OPTIONS`. Supply one of the two.

## Example

*Illustrative* — a file_fdw table with no source.

```text
ERROR:  either filename or program is required for file_fdw foreign tables
```

## Related

- [foreign-data wrapper has no handler](./foreign-data-wrapper-has-no-handler.md)
- [foreign table does not exist](./foreign-table-does-not-exist.md)
