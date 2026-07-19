---
message: "cannot alter statistics on included column \"%s\" of index \"%s\""
slug: cannot-alter-statistics-on-included-column-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9143"
reproduced: false
---

# `cannot alter statistics on included column "%s" of index "%s"`

## What it means

An `ALTER INDEX ... ALTER COLUMN ... SET STATISTICS` targeted a column that is an `INCLUDE` payload of the index. The placeholders name the column and index. Included columns are stored but not used as keys, so per-column statistics do not apply to them.

## When it happens

It occurs when setting a statistics target on a column that the index carries via `INCLUDE` rather than as a key column.

## How to fix

Set statistics only on key columns of the index, or on expression columns. Included columns hold data for index-only scans and have no independent statistics target to adjust.

## Example

*Illustrative* — statistics on an INCLUDE column.

```sql
ALTER INDEX idx ALTER COLUMN 2 SET STATISTICS 100;
```

## Related

- [cannot alter statistics on non-expression column of index](./cannot-alter-statistics-on-non-expression-column-of-index.md)
- [cannot alter statistics on virtual generated column](./cannot-alter-statistics-on-virtual-generated-column.md)
