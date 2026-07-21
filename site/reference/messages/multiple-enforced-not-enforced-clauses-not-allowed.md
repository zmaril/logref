---
message: "multiple ENFORCED/NOT ENFORCED clauses not allowed"
slug: multiple-enforced-not-enforced-clauses-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4321"
  - "postgres/src/backend/parser/parse_utilcmd.c:4338"
reproduced: false
---

# `multiple ENFORCED/NOT ENFORCED clauses not allowed`

## What it means

A constraint definition specified both `ENFORCED` and `NOT ENFORCED` (or repeated one). A constraint may carry only one enforcement setting.

## When it happens

It arises in constraint definitions that use the enforcement clause more than once, for example on a check or foreign-key constraint.

## How to fix

Use a single enforcement clause — `ENFORCED` or `NOT ENFORCED` — and remove the duplicate or conflicting one.

## Example

*Illustrative* — conflicting enforcement clauses.

```sql
... CHECK (x > 0) ENFORCED NOT ENFORCED;  -- pick one
```

## Related

- [multiple DEFERRABLE/NOT DEFERRABLE clauses not allowed](./multiple-deferrable-not-deferrable-clauses-not-allowed.md)
- [multiple INITIALLY IMMEDIATE/DEFERRED clauses not allowed](./multiple-initially-immediate-deferred-clauses-not-allowed.md)
