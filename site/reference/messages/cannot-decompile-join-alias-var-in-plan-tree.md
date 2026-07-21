---
message: "cannot decompile join alias var in plan tree"
slug: cannot-decompile-join-alias-var-in-plan-tree
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8332"
  - "postgres/src/backend/utils/adt/ruleutils.c:8856"
reproduced: false
---

# `cannot decompile join alias var in plan tree`

## What it means

Internal error. The rule/expression deparser (used by `EXPLAIN`, view definitions, and `pg_get_*def` functions) encountered a join-alias variable in a finished plan tree that it should have resolved before this stage. It is a consistency check inside the deparser.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in how a plan tree was built or serialized, not to anything you can change in your query.

## How to fix

Treat it as an internal bug. Capture the statement that triggered the deparse (often an `EXPLAIN` or a catalog function over a view) and report it with the view or query definition involved.

## Example

*Illustrative* — emitted internally while deparsing a plan.

```text
ERROR:  cannot decompile join alias var in plan tree
```

## Related

- [could not find junk wholerow column](./could-not-find-junk-wholerow-column.md)
- [cannot get type for untransformed sublink](./cannot-get-type-for-untransformed-sublink.md)
