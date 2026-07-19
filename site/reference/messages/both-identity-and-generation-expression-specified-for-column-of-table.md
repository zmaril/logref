---
message: "both identity and generation expression specified for column \"%s\" of table \"%s\""
slug: both-identity-and-generation-expression-specified-for-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:983"
reproduced: false
---

# `both identity and generation expression specified for column "%s" of table "%s"`

## What it means

A column definition supplied both a `GENERATED ... AS IDENTITY` clause and a `GENERATED ... AS (expression)` clause. Identity draws values from a sequence and a generated column computes from other columns; a column can be one but not both. The placeholders name the column and table.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE` when a column combines identity with a generation expression.

## How to fix

Decide whether the column is an identity column or a computed generated column, and keep only that clause. The two mechanisms are mutually exclusive.

## Example

*Illustrative* — identity and generation on one column.

```sql
CREATE TABLE t (a int, b int GENERATED ALWAYS AS IDENTITY GENERATED ALWAYS AS (a) STORED);
```

## Related

- [both default and identity specified for column of table](./both-default-and-identity-specified-for-column-of-table.md)
- [both default and generation expression specified for column of table](./both-default-and-generation-expression-specified-for-column-of-table.md)
