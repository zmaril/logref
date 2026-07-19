---
message: "combinefn not set for aggregate function"
slug: combinefn-not-set-for-aggregate-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:3951"
reproduced: false
---

# `combinefn not set for aggregate function`

## What it means

The executor tried to run an aggregate in partial/parallel mode, but the aggregate has no combine function defined. Without a combine function, partial aggregate states cannot be merged. This is an internal check.

## When it happens

It fires during partial or parallel aggregation when the planner chose a partial-aggregate path for an aggregate whose catalog entry lacks a `combinefunc`.

## How to fix

This should not occur for the built-in aggregates. If it happens with a custom aggregate, define a `COMBINEFUNC` for it or avoid parallel/partial aggregation for it; if it happens with a built-in aggregate, treat it as a bug to report with the query that triggered it.

## Example

*Illustrative* — a partial aggregate lacking a combine function.

```text
ERROR:  combinefn not set for aggregate function
```

## Related

- [combining Aggref does not point to an Aggref](./combining-aggref-does-not-point-to-an-aggref.md)
- [aggregate function cannot register a callback in this context](./aggregate-function-cannot-register-a-callback-in-this-context.md)
