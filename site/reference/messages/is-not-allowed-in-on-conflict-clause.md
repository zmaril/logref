---
message: "%s is not allowed in ON CONFLICT clause"
slug: is-not-allowed-in-on-conflict-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3433"
  - "postgres/src/backend/parser/parse_clause.c:3439"
reproduced: false
---

# `%s is not allowed in ON CONFLICT clause`

## What it means

A construct appears inside an `ON CONFLICT` clause where it is not permitted. The placeholder names the disallowed element. The conflict clause accepts only a limited set of references and expressions.

## When it happens

It arises in `INSERT ... ON CONFLICT ... DO UPDATE` when the clause references something not allowed there — for example an aggregate, a window function, or a disallowed column reference in the conflict target or update expression.

## How to fix

Remove the disallowed construct from the `ON CONFLICT` clause. Reference the special `excluded` row and the target table's columns as documented, and move aggregates or subqueries out of the conflict handling. Consult the `INSERT` documentation for what the clause permits.

## Example

*Illustrative* — an aggregate inside ON CONFLICT.

```sql
INSERT INTO t VALUES (1) ON CONFLICT (id) DO UPDATE SET n = sum(t.n);  -- not allowed
```

## Related

- [ON CONFLICT DO SELECT requires a RETURNING clause](./on-conflict-do-select-requires-a-returning-clause.md)
- [only WITH CHECK expression allowed for INSERT](./only-with-check-expression-allowed-for-insert.md)
