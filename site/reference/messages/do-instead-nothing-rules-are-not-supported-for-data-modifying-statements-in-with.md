---
message: "DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH"
slug: do-instead-nothing-rules-are-not-supported-for-data-modifying-statements-in-with
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4113"
reproduced: false
---

# `DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH`

## What it means

A data-modifying statement inside a `WITH` clause targeted a relation with a `DO INSTEAD NOTHING` rule. The rewrite system cannot apply that rule to a writable CTE.

## When it happens

It fires when a `WITH ... AS (INSERT/UPDATE/DELETE ...)` targets a relation whose rules include `DO INSTEAD NOTHING`.

## How to fix

Move the data-modifying statement to the top level, outside the `WITH`, where the rule applies. Or target a relation without the conflicting rule.

## Example

*Illustrative* — a writable CTE on a table with a DO INSTEAD NOTHING rule.

```text
ERROR:  DO INSTEAD NOTHING rules are not supported for data-modifying statements in WITH
```

## Related

- [DO INSTEAD NOTHING rules are not supported for COPY](./do-instead-nothing-rules-are-not-supported-for-copy.md)
- [DO INSTEAD NOTIFY rules are not supported for data-modifying statements in WITH](./do-instead-notify-rules-are-not-supported-for-data-modifying-statements-in-with.md)
