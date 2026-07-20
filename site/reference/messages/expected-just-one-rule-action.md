---
message: "expected just one rule action"
slug: expected-just-one-rule-action
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1774"
reproduced: false
---

# `expected just one rule action`

## What it means

An internal guard in the rewrite system. Processing a rule (typically the implicit `ON SELECT` rule that defines a view), it expected exactly one rule action and found a different number. It is a shape check on rule definitions.

## When it happens

It fires while the rewriter expands a view or rule and the stored rule does not have the single action it requires. In a healthy database this cannot happen for a normally created view.

## How to fix

This is an internal invariant, not a user setting. It points at an inconsistent or manually altered rule in the catalog. Confirm nobody edited `pg_rewrite` directly. Recreating the affected view or rule from its definition usually resolves it; report it if the object was created normally.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected just one rule action
```

## Related

- [event qualifications are not implemented for rules on SELECT](./event-qualifications-are-not-implemented-for-rules-on-select.md)
- [expandTableLikeClause called on untransformed LIKE clause](./expandtablelikeclause-called-on-untransformed-like-clause.md)
