---
message: "DO ALSO rules are not supported for data-modifying statements in WITH"
slug: do-also-rules-are-not-supported-for-data-modifying-statements-in-with
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4131"
reproduced: false
---

# `DO ALSO rules are not supported for data-modifying statements in WITH`

## What it means

A data-modifying statement inside a `WITH` clause (a writable CTE) targeted a relation that has a `DO ALSO` rule. The rewrite system cannot apply `DO ALSO` rules to CTEs that modify data.

## When it happens

It fires when a query uses `WITH ... AS (INSERT/UPDATE/DELETE ...)` on a relation whose rules include a `DO ALSO` action.

## How to fix

Run the data-modifying statement outside the `WITH` clause as a top-level command, where the rule can be applied. Alternatively, restructure so the CTE targets a relation without conflicting rules.

## Example

*Illustrative* — a writable CTE on a table with a DO ALSO rule.

```text
ERROR:  DO ALSO rules are not supported for data-modifying statements in WITH
```

## Related

- [DO ALSO rules are not supported for COPY](./do-also-rules-are-not-supported-for-copy.md)
- [DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH](./do-instead-nothing-rules-are-not-supported-for-data-modifying-statements-in-with.md)
