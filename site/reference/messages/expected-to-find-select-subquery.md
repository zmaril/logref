---
message: "expected to find SELECT subquery"
slug: expected-to-find-select-subquery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteManip.c:1117"
  - "postgres/src/backend/rewrite/rewriteManip.c:1120"
  - "postgres/src/backend/rewrite/rewriteManip.c:1126"
reproduced: false
---

# `expected to find SELECT subquery`

## What it means

Internal error. Query-rewriting code expected a particular range-table entry to contain a `SELECT` subquery and found something else. The placeholder-free message is a consistency check in the rewriter, which assumes a specific query shape at that point.

## When it happens

It does not arise from ordinary SQL. It points to a bug in rule/view rewriting or in code that manipulates query trees, rather than to the query text a user wrote.

## How to fix

Treat it as an internal bug. If it appears with a specific view or rule, capture that definition and the triggering statement and report it. There is no data-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally by the rewriter.

```text
ERROR:  expected to find SELECT subquery
```

## Related

- [subquery does not have attribute](./subquery-does-not-have-attribute.md)
- [unrecognized token](./unrecognized-token.md)
