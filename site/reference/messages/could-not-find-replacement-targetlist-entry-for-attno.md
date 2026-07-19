---
message: "could not find replacement targetlist entry for attno %d"
slug: could-not-find-replacement-targetlist-entry-for-attno
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteManip.c:1884"
reproduced: false
---

# `could not find replacement targetlist entry for attno %d`

## What it means

The query rewriter could not find the target-list entry it needed to substitute for an attribute. The `%d` is the attribute number. This is an internal invariant of the rewrite phase.

## When it happens

It fires while the rewriter maps attributes through a view or rule expansion and an expected target-list entry is missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query against a view or a table with rules triggers it, note the exact statement and the view or rule definitions and report a reproducible case.

## Example

*Illustrative* — a missing target-list entry during rewrite.

```text
ERROR:  could not find replacement targetlist entry for attno 4
```

## Related

- [could not find rule placeholders](./could-not-find-rule-placeholders.md)
- [could not find GROUP clause for GROUP Var attno](./could-not-find-group-clause-for-group-var-attno.md)
