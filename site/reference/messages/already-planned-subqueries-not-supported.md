---
message: "already-planned subqueries not supported"
slug: already-planned-subqueries-not-supported
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/dependency.c:2059"
reproduced: false
---

# `already-planned subqueries not supported`

## What it means

The planner was handed a subquery that had already been planned when it expected an unplanned query tree, a combination its code path does not support — an internal guard.

## When it happens

It is raised on an internal planning path if a sub-plan appears where a raw subquery was expected, typically through a bug or an extension manipulating plan trees.

## How to fix

This is an internal error rather than a query you can rewrite. If it recurs, capture the statement, `EXPLAIN` output, and any planner-related extensions and report it. There is no user-level workaround.

## Example

*Illustrative* — an already-planned subquery reaching the planner.

```text
ERROR:  already-planned subqueries not supported
```

## Related

- [any/all subselect unsupported as initplan](./any-all-subselect-unsupported-as-initplan.md)
- [append child's targetlist doesn't match Append](./append-child-s-targetlist-doesn-t-match-append.md)
