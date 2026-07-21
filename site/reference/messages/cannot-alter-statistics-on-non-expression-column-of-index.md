---
message: "cannot alter statistics on non-expression column \"%s\" of index \"%s\""
slug: cannot-alter-statistics-on-non-expression-column-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9148"
reproduced: false
---

# `cannot alter statistics on non-expression column "%s" of index "%s"`

## What it means

An `ALTER INDEX ... ALTER COLUMN ... SET STATISTICS` targeted an index column that is a plain table column rather than an expression. The placeholders name the column and index. On an index, a statistics target can be set only for expression columns.

## When it happens

It occurs when setting a statistics target on a simple (non-expression) column of an index.

## How to fix

Set the statistics target on the table column itself with `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS`. Use the index form only for the index's expression columns, which have no table column to carry statistics.

## Example

*Illustrative* — statistics on a plain index column.

```sql
ALTER INDEX idx ALTER COLUMN 1 SET STATISTICS 100;
```

## Related

- [cannot alter statistics on included column of index](./cannot-alter-statistics-on-included-column-of-index.md)
- [cannot alter statistics on virtual generated column](./cannot-alter-statistics-on-virtual-generated-column.md)
