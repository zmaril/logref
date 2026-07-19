---
message: "Aggref found where not expected"
slug: aggref-found-where-not-expected
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/var.c:699"
reproduced: false
---

# `Aggref found where not expected`

## What it means

Expression processing encountered an aggregate reference (`Aggref`) in a place where aggregates are not permitted, which a correct plan or parse tree should never produce — an internal consistency guard.

## When it happens

It is raised when an aggregate expression appears in a context the code assumed was aggregate-free, generally through a planner or rewriter bug or malformed nodes from an extension.

## How to fix

This is an internal error, not a user SQL fault. If it appears, capture the statement and any extensions that build or transform expressions and report it. There is no query-level workaround.

## Example

*Illustrative* — an aggregate reference where none is allowed.

```text
ERROR:  Aggref found where not expected
```

## Related

- [Aggref found in non-Agg plan node](./aggref-found-in-non-agg-plan-node.md)
- [any/all subselect unsupported as initplan](./any-all-subselect-unsupported-as-initplan.md)
