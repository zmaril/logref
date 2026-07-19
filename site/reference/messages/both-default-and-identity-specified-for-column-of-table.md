---
message: "both default and identity specified for column \"%s\" of table \"%s\""
slug: both-default-and-identity-specified-for-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:967"
reproduced: false
---

# `both default and identity specified for column "%s" of table "%s"`

## What it means

A column definition supplied both a `DEFAULT` clause and a `GENERATED ... AS IDENTITY` clause. An identity column already generates its values from a sequence, so it cannot also have a default. The placeholders name the column and table.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE` when a column combines `DEFAULT` with an identity specification.

## How to fix

Keep either the `DEFAULT` or the identity clause, not both. Use identity for an auto-incrementing key, or a plain default for a normal column, and drop the conflicting clause.

## Example

*Illustrative* — default and identity on one column.

```sql
CREATE TABLE t (id int DEFAULT 0 GENERATED ALWAYS AS IDENTITY);
```

## Related

- [both default and generation expression specified for column of table](./both-default-and-generation-expression-specified-for-column-of-table.md)
- [both identity and generation expression specified for column of table](./both-identity-and-generation-expression-specified-for-column-of-table.md)
