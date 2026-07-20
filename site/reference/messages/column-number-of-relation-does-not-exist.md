---
message: "column number %d of relation \"%s\" does not exist"
slug: column-number-of-relation-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9114"
reproduced: false
---

# `column number %d of relation "%s" does not exist`

## What it means

A statement referenced a column of a relation by number, and that number is outside the relation's set of columns. The numbered column does not exist.

## When it happens

It happens in commands that address columns positionally (some `ALTER TABLE` internals, statistics targets, or tooling) when the given column number is too large or points at a dropped column.

## How to fix

Use a valid column number or, better, refer to the column by name. Check the table's current columns with `\d table` and account for any dropped columns.

## Example

*Illustrative* — a column number past the end of the table.

```text
ERROR:  column number 9 of relation "t" does not exist
```

## Related

- [column number out of range](./column-number-out-of-range.md)
- [column named in partition key does not exist](./column-named-in-partition-key-does-not-exist.md)
