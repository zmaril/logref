---
message: "predicate_classify returned a bogus value"
slug: predicate-classify-returned-a-bogus-value
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/predtest.c:497"
  - "postgres/src/backend/optimizer/util/predtest.c:808"
reproduced: false
---

# `predicate_classify returned a bogus value`

## What it means

Internal planner error. The routine that classifies a predicate expression for index/quals processing returned a value outside its defined set of categories.

## When it happens

It fires from planner predicate-analysis code (used, for example, in partial-index matching and constraint exclusion) when the classifier reaches an unexpected result. Ordinary queries do not raise it.

## How to fix

This is an internal consistency guard. If reproducible, capture the query and any partial-index or constraint definitions involved and report it as a planner bug.

## Example

*Illustrative* — the predicate classifier returning an undefined value.

```text
ERROR:  predicate_classify returned a bogus value
```

## Related

- [outer pathkeys do not match mergeclauses](./outer-pathkeys-do-not-match-mergeclauses.md)
- [subquery is bogus](./subquery-is-bogus.md)
