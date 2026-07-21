---
message: "cannot handle qualified ON SELECT rule"
slug: cannot-handle-qualified-on-select-rule
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1776"
reproduced: false
---

# `cannot handle qualified ON SELECT rule`

## What it means

An internal guard in the rewriter fired: it encountered an `ON SELECT` rule that carries a qualification (a `WHERE` condition). An `ON SELECT` rule that defines a view must be unconditional, so a qualified one cannot be handled.

## When it happens

It is reached when the rewriter processes a view's `ON SELECT` rule that somehow has a qualification attached. It reflects catalog inconsistency or a coding issue rather than a normal user action.

## How to fix

There is no user-level fix. If it appears, capture the view definition and how the rule was created and report it, since view-defining rules should never carry a qualification.

## Example

*Illustrative* — a qualified ON SELECT rule.

```text
ERROR:  cannot handle qualified ON SELECT rule
```

## Related

- [cannot handle unplanned sub-select](./cannot-handle-unplanned-sub-select.md)
- [cannot have multiple RETURNING lists in a rule](./cannot-have-multiple-returning-lists-in-a-rule.md)
