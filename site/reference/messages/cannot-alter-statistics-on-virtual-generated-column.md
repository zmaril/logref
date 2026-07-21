---
message: "cannot alter statistics on virtual generated column \"%s\""
slug: cannot-alter-statistics-on-virtual-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9134"
reproduced: false
---

# `cannot alter statistics on virtual generated column "%s"`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` targeted a virtual generated column. The placeholder is the column. A virtual generated column is computed on read and not stored, so it has no stored statistics to configure.

## When it happens

It occurs when setting a statistics target on a column defined as `GENERATED ALWAYS AS (...) VIRTUAL`.

## How to fix

Do not set statistics on virtual generated columns. If you need statistics for planning on the computed value, consider a stored generated column or an expression index, which do carry statistics.

## Example

*Illustrative* — statistics on a virtual column.

```sql
ALTER TABLE t ALTER COLUMN g SET STATISTICS 100;
```

## Related

- [cannot alter statistics on non-expression column of index](./cannot-alter-statistics-on-non-expression-column-of-index.md)
- [cannot alter statistics on included column of index](./cannot-alter-statistics-on-included-column-of-index.md)
