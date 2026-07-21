---
message: "expression contains variables of more than one relation"
slug: expression-contains-variables-of-more-than-one-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:3110"
reproduced: false
---

# `expression contains variables of more than one relation`

## What it means

An expression that must reference at most one relation referenced columns from several. The placeholder-free message names the constraint: only single-relation column references are allowed in this position.

## When it happens

It fires from features that require a single-relation expression — for example an index expression or a per-relation statistics expression — when the expression mixes columns from more than one table.

## How to fix

Restrict the expression to columns of one relation. Index and per-table expressions can only use that table's own columns; you cannot build one across a join. If you need a cross-table computation, materialize it (for example in a generated column populated by a trigger, or a separate table) and index or analyze that instead.

## Example

*Illustrative* — an index expression uses one table's columns only.

```sql
CREATE INDEX ON orders ((total + tax));  -- both columns from orders
```

## Related

- [expression contains variables](./expression-contains-variables.md)
- [expression not found in statistics object](./expression-not-found-in-statistics-object.md)
