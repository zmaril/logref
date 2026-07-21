---
message: "DO INSTEAD NOTIFY rules are not supported for data-modifying statements in WITH"
slug: do-instead-notify-rules-are-not-supported-for-data-modifying-statements-in-with
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4102"
reproduced: false
---

# `DO INSTEAD NOTIFY rules are not supported for data-modifying statements in WITH`

## What it means

A data-modifying statement inside a `WITH` clause targeted a relation with a `DO INSTEAD ... NOTIFY` rule. The rewrite system cannot apply a `NOTIFY` rule to a writable CTE.

## When it happens

It fires when a `WITH ... AS (INSERT/UPDATE/DELETE ...)` targets a relation whose rule issues a `NOTIFY`.

## How to fix

Run the data-modifying statement at the top level, outside the `WITH`, so the `NOTIFY` rule can fire. Or issue the `NOTIFY` explicitly from application code instead of relying on the rule.

## Example

*Illustrative* — a writable CTE on a table with a NOTIFY rule.

```text
ERROR:  DO INSTEAD NOTIFY rules are not supported for data-modifying statements in WITH
```

## Related

- [DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH](./do-instead-nothing-rules-are-not-supported-for-data-modifying-statements-in-with.md)
- [DO ALSO rules are not supported for data-modifying statements in WITH](./do-also-rules-are-not-supported-for-data-modifying-statements-in-with.md)
