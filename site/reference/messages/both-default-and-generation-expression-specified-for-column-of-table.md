---
message: "both default and generation expression specified for column \"%s\" of table \"%s\""
slug: both-default-and-generation-expression-specified-for-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:975"
reproduced: false
---

# `both default and generation expression specified for column "%s" of table "%s"`

## What it means

A column definition supplied both a `DEFAULT` clause and a `GENERATED ... AS` expression. A column may have one or the other, since a generated column computes its value and cannot also carry a default. The placeholders name the column and table.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE` when a column definition combines `DEFAULT` with `GENERATED ALWAYS AS (...) STORED`.

## How to fix

Choose one. Keep `DEFAULT` for a plain column whose value can be supplied or defaulted, or keep the generation expression for a computed column, and remove the other clause.

## Example

*Illustrative* — default and generation on one column.

```sql
CREATE TABLE t (a int, b int DEFAULT 0 GENERATED ALWAYS AS (a + 1) STORED);
```

## Related

- [both default and identity specified for column of table](./both-default-and-identity-specified-for-column-of-table.md)
- [both identity and generation expression specified for column of table](./both-identity-and-generation-expression-specified-for-column-of-table.md)
