---
message: "multiple DEFERRABLE/NOT DEFERRABLE clauses not allowed"
slug: multiple-deferrable-not-deferrable-clauses-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4242"
  - "postgres/src/backend/parser/parse_utilcmd.c:4257"
reproduced: false
---

# `multiple DEFERRABLE/NOT DEFERRABLE clauses not allowed`

## What it means

A constraint definition specified both `DEFERRABLE` and `NOT DEFERRABLE` (or repeated one of them). Only a single deferrability setting is allowed per constraint.

## When it happens

It arises in `CREATE TABLE`/`ALTER TABLE ... ADD CONSTRAINT` (or `SET CONSTRAINTS`-adjacent definitions) when the deferrability clause appears more than once.

## How to fix

Give the constraint one deferrability clause: either `DEFERRABLE` or `NOT DEFERRABLE`, not both. Remove the duplicate from the definition.

## Example

*Illustrative* — conflicting deferrability clauses.

```sql
... FOREIGN KEY (a) REFERENCES p DEFERRABLE NOT DEFERRABLE;  -- pick one
```

## Related

- [multiple INITIALLY IMMEDIATE/DEFERRED clauses not allowed](./multiple-initially-immediate-deferred-clauses-not-allowed.md)
- [multiple ENFORCED/NOT ENFORCED clauses not allowed](./multiple-enforced-not-enforced-clauses-not-allowed.md)
