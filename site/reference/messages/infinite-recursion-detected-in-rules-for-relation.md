---
message: "infinite recursion detected in rules for relation \"%s\""
slug: infinite-recursion-detected-in-rules-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:2190"
  - "postgres/src/backend/rewrite/rewriteHandler.c:4494"
reproduced: false
---

# `infinite recursion detected in rules for relation "%s"`

## What it means

A query on a relation could not be rewritten because its rules refer back to the same relation in a way that never terminates. The rule rewriter caps recursion depth and reports this rather than looping forever.

## When it happens

It typically involves a view or a table with `ON SELECT`/`DO INSTEAD` rules that ultimately query the same relation — for example a view defined in terms of itself, or two rules that reference each other cyclically.

## How to fix

Break the cycle in the rule or view definitions. Redefine the view so it selects from base tables rather than from itself, or remove the self-referential `DO INSTEAD` rule. Inspect the definitions with `\d+ relname` and `pg_rules` to find the loop.

## Example

*Illustrative* — a view that selects from itself.

```sql
CREATE VIEW v AS SELECT * FROM v;  -- infinite recursion in rules
```

## Related

- [non-view rule for must not be named](./non-view-rule-for-must-not-be-named.md)
- [ON CONFLICT DO SELECT requires a RETURNING clause](./on-conflict-do-select-requires-a-returning-clause.md)
