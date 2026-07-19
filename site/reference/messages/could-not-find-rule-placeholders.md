---
message: "could not find rule placeholders"
slug: could-not-find-rule-placeholders
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteManip.c:1138"
reproduced: false
---

# `could not find rule placeholders`

## What it means

The query rewriter could not find the placeholder entries it uses while expanding a rule. This is an internal invariant of rule rewriting.

## When it happens

It fires while the rewriter processes a rule (such as an `ON INSERT`/`ON UPDATE` rule or an updatable-view rule) and the expected placeholders are missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific statement against a table or view with rules triggers it, note the exact statement and the rule definitions and report a reproducible case.

## Example

*Illustrative* — missing rule placeholders during rewrite.

```text
ERROR:  could not find rule placeholders
```

## Related

- [could not find replacement targetlist entry for attno](./could-not-find-replacement-targetlist-entry-for-attno.md)
- [could not find JoinExpr for whole-row reference](./could-not-find-joinexpr-for-whole-row-reference.md)
