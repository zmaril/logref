---
message: "conditional DO INSTEAD rules are not supported for data-modifying statements in WITH"
slug: conditional-do-instead-rules-are-not-supported-for-data-modifying-statements-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4127"
reproduced: false
---

# `conditional DO INSTEAD rules are not supported for data-modifying statements in WITH`

## What it means

A data-modifying statement inside a `WITH` clause targeted a relation carrying a conditional `DO INSTEAD` rule. Rewriting such statements with conditional rules inside CTEs is not supported.

## When it happens

It happens when an `INSERT`/`UPDATE`/`DELETE` in a `WITH` (CTE) targets a table or view that has a conditional `DO INSTEAD` rule.

## How to fix

Move the data-modifying statement out of the `WITH` clause, target the base table directly, or replace the conditional rule with an unconditional rule or a trigger.

## Example

*Illustrative* — a data-modifying CTE against a conditionally-ruled relation.

```text
ERROR:  conditional DO INSTEAD rules are not supported for data-modifying statements in WITH
```

## Related

- [conditional DO INSTEAD rules are not supported for COPY](./conditional-do-instead-rules-are-not-supported-for-copy.md)
- [conditional utility statements are not implemented](./conditional-utility-statements-are-not-implemented.md)
