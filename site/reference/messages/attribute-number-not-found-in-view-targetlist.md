---
message: "attribute number %d not found in view targetlist"
slug: attribute-number-not-found-in-view-targetlist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3189"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3755"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3775"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3812"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3891"
reproduced: false
---

# `attribute number %d not found in view targetlist`

## What it means

Internal error. The rewriter, expanding a view or a rule, looked for a column by its attribute number in the view's target list and did not find it. The placeholder is the attribute number. It is a consistency check between the view's stored definition and the rule being applied.

## When it happens

It should not occur for normally-defined views. Reaching it suggests catalog inconsistency between a view's rule and its column list, or a bug in rule rewriting.

## How to fix

Treat it as an internal bug. If it recurs on a specific view, inspect and consider recreating that view. Capture the view definition and the failing query and report it.

## Example

*Illustrative* — emitted internally during view rewriting.

```text
ERROR:  attribute number 3 not found in view targetlist
```

## Related

- [default expression not found for attribute of relation](./default-expression-not-found-for-attribute-of-relation.md)
- [record has no field](./record-has-no-field.md)
