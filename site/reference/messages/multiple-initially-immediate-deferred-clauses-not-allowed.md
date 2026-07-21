---
message: "multiple INITIALLY IMMEDIATE/DEFERRED clauses not allowed"
slug: multiple-initially-immediate-deferred-clauses-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4278"
  - "postgres/src/backend/parser/parse_utilcmd.c:4304"
reproduced: false
---

# `multiple INITIALLY IMMEDIATE/DEFERRED clauses not allowed`

## What it means

A constraint definition specified the initial timing more than once (`INITIALLY IMMEDIATE` and `INITIALLY DEFERRED`, or a repeat). Only one initial-timing clause is allowed.

## When it happens

It arises in `CREATE`/`ALTER TABLE` constraint definitions where the `INITIALLY ...` clause appears twice.

## How to fix

Give the constraint a single initial-timing clause, either `INITIALLY IMMEDIATE` or `INITIALLY DEFERRED`. Remove the duplicate. Note this only applies to `DEFERRABLE` constraints.

## Example

*Illustrative* — conflicting initial timing.

```sql
... DEFERRABLE INITIALLY IMMEDIATE INITIALLY DEFERRED;  -- pick one
```

## Related

- [multiple DEFERRABLE/NOT DEFERRABLE clauses not allowed](./multiple-deferrable-not-deferrable-clauses-not-allowed.md)
- [multiple ENFORCED/NOT ENFORCED clauses not allowed](./multiple-enforced-not-enforced-clauses-not-allowed.md)
