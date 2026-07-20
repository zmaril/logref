---
message: "cannot have multiple RETURNING lists in a rule"
slug: cannot-have-multiple-returning-lists-in-a-rule
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:430"
reproduced: false
---

# `cannot have multiple RETURNING lists in a rule`

## What it means

A single rule definition contained more than one `RETURNING` list. A rule may carry at most one `RETURNING` clause, so a second one is rejected.

## When it happens

It occurs when a `CREATE RULE` body includes several actions and more than one of them has a `RETURNING` clause.

## How to fix

Keep at most one `RETURNING` list in the rule. Consolidate the actions so a single one returns rows, or redesign the logic using triggers where per-action returning is needed.

## Example

*Illustrative* — two RETURNING lists in one rule.

```text
ERROR:  cannot have multiple RETURNING lists in a rule
```

## Related

- [cannot have RETURNING lists in multiple rules](./cannot-have-returning-lists-in-multiple-rules.md)
- [cannot handle qualified ON SELECT rule](./cannot-handle-qualified-on-select-rule.md)
