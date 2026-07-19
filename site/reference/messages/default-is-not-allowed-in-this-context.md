---
message: "DEFAULT is not allowed in this context"
slug: default-is-not-allowed-in-this-context
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:312"
reproduced: false
---

# `DEFAULT is not allowed in this context`

## What it means

The `DEFAULT` keyword appeared somewhere it has no meaning. `DEFAULT` as a value is only valid in specific places, such as an `INSERT` column value or an `UPDATE` assignment.

## When it happens

It fires during parse analysis when `DEFAULT` is used as an expression outside the contexts that accept it — for instance in a `SELECT` list, a `WHERE` clause, or a general expression.

## How to fix

Use `DEFAULT` only where the SQL standard allows it: in the `VALUES` of an `INSERT`, or on the right-hand side of an `UPDATE ... SET col = DEFAULT`. Elsewhere, write the actual value or expression you intend.

## Example

*Illustrative* — `DEFAULT` in a `SELECT` list.

```sql
SELECT DEFAULT FROM t;  -- DEFAULT is not allowed in this context
```

## Related

- [DEFAULT expression must not contain column references](./default-expression-must-not-contain-column-references.md)
- [DEFAULT expression must not return a set](./default-expression-must-not-return-a-set.md)
