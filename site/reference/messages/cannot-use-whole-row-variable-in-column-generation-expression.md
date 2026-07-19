---
message: "cannot use whole-row variable in column generation expression"
slug: cannot-use-whole-row-variable-in-column-generation-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3230"
reproduced: false
---

# `cannot use whole-row variable in column generation expression`

## What it means

A generated column's expression referenced the table's whole-row variable. A generation expression may read only the row's individual stored columns, so a whole-row reference, which would include the generated column itself, is not allowed.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE` when a `GENERATED ALWAYS AS (...)` expression uses the table name as a composite value.

## How to fix

Rewrite the expression to name the specific columns it needs instead of the whole row. Reference each stored column directly.

## Example

*Illustrative* — a whole-row reference in a generation expression.

```sql
CREATE TABLE t (a int, g text GENERATED ALWAYS AS (t::text) STORED);
-- ERROR:  cannot use whole-row variable in column generation expression
```

## Related

- [cannot use generated column in column generation expression](./cannot-use-generated-column-in-column-generation-expression.md)
- [cannot use system column in column generation expression](./cannot-use-system-column-in-column-generation-expression.md)
