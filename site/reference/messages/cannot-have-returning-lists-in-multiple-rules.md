---
message: "cannot have RETURNING lists in multiple rules"
slug: cannot-have-returning-lists-in-multiple-rules
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:720"
reproduced: false
---

# `cannot have RETURNING lists in multiple rules`

## What it means

More than one rule on the same event carried a `RETURNING` list. Only one rule for a given operation may define what the statement returns, so a `RETURNING` list in a second rule is rejected.

## When it happens

It occurs when you create several rules on the same table and event (for example two `ON INSERT` rules) and more than one of them has a `RETURNING` clause.

## How to fix

Keep `RETURNING` in a single rule for the event. Remove it from the other rules, or combine the logic so one rule owns the returned rows.

## Example

*Illustrative* — RETURNING in two rules for the same event.

```text
ERROR:  cannot have RETURNING lists in multiple rules
```

## Related

- [cannot have multiple RETURNING lists in a rule](./cannot-have-multiple-returning-lists-in-a-rule.md)
- [cannot handle qualified ON SELECT rule](./cannot-handle-qualified-on-select-rule.md)
