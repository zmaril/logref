---
message: "cannot refer to non-index column by number"
slug: cannot-refer-to-non-index-column-by-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9062"
reproduced: false
---

# `cannot refer to non-index column by number`

## What it means

An `ALTER TABLE` subcommand referenced a column by number in a context that applies to index columns, but the number does not correspond to an index column. Only index-defined columns can be addressed by position here.

## When it happens

It occurs when a statistics-target or similar subcommand on an index uses a column number that points at a plain stored column rather than an expression column of the index.

## How to fix

Reference plain columns by name, and use column numbers only for expression columns of an index (which have no name). Check the index definition to see which columns are addressable by number.

## Example

*Illustrative* — a non-index column referenced by number.

```text
ERROR:  cannot refer to non-index column by number
```

## Related

- [cannot rename column of typed table](./cannot-rename-column-of-typed-table.md)
- [cannot recursively add identity column to table that has child tables](./cannot-recursively-add-identity-column-to-table-that-has-child-tables.md)
