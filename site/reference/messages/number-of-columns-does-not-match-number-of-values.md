---
message: "number of columns does not match number of values"
slug: number-of-columns-does-not-match-number-of-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:1543"
  - "postgres/src/backend/parser/parse_expr.c:1575"
reproduced: false
---

# `number of columns does not match number of values`

## What it means

A statement paired a list of columns with a list of values of a different length. The two lists must have the same count so each column gets one value.

## When it happens

It arises in `INSERT INTO t (a, b) VALUES (1)`, a multi-column `UPDATE ... SET (a, b) = (...)`, or a row-comparison where the column and value counts differ.

## How to fix

Make the column list and the value list the same length. Add the missing value or remove the extra column, and check for a miscounted `VALUES` row or an unbalanced multi-column assignment.

## Example

*Illustrative* — column and value counts differ.

```sql
INSERT INTO t (a, b) VALUES (1);  -- two columns, one value
```

## Related

- [number of aliases does not match number of columns](./number-of-aliases-does-not-match-number-of-columns.md)
- [multiple assignments to same column](./multiple-assignments-to-same-column.md)
