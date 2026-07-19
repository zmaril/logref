---
message: "no generation expression found for column number %d of table \"%s\""
slug: no-generation-expression-found-for-column-number-of-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:502"
  - "postgres/src/backend/rewrite/rewriteHandler.c:4747"
reproduced: false
---

# `no generation expression found for column number %d of table "%s"`

## What it means

Internal error. Code that computes a generated column's value could not find the stored generation expression for that column. The placeholders are the column number and table. It is a consistency guard over generated-column metadata.

## When it happens

It fires when evaluating a `GENERATED ALWAYS AS (...) STORED` column whose expression is missing from the catalog. A normally defined generated column always has one; this points to corrupted `pg_attrdef`/catalog data or an internal inconsistency.

## How to fix

This is a can't-happen guard. If a specific table triggers it, its generated-column metadata may be damaged — inspect the column with `\d+` and consider redefining it. Capture the table definition and report a reproducible case.

## Example

*Illustrative* — a generated column missing its expression.

```text
ERROR:  no generation expression found for column number 3 of table "my_table"
```

## Related

- [null conbin for relation](./null-conbin-for-relation.md)
- [invalid action for foreign key constraint containing generated column](./invalid-action-for-foreign-key-constraint-containing-generated-column.md)
