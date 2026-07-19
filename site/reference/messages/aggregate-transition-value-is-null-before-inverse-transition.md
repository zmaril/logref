---
message: "aggregate transition value is NULL before inverse transition"
slug: aggregate-transition-value-is-null-before-inverse-transition
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:535"
reproduced: false
---

# `aggregate transition value is NULL before inverse transition`

## What it means

While computing a moving aggregate over a window frame, the executor was asked to remove a row via the inverse transition function but the running state was already NULL, which should not happen and indicates the aggregate's transition and inverse functions are inconsistent.

## When it happens

It is raised during windowed aggregation when the inverse function is invoked on a NULL state, typically because a custom moving aggregate's forward and inverse functions do not agree on how state evolves.

## How to fix

This points at a bug in a moving-aggregate implementation rather than the SQL that calls it. If a specific aggregate triggers it, report it to that aggregate's author. As a workaround, avoid window frames that force the problematic removal, or use a non-moving equivalent.

## Example

*Illustrative* — an inverse transition on a NULL moving-aggregate state.

```text
ERROR:  aggregate transition value is NULL before inverse transition
```

## Related

- [aggregate minvfunc must be specified when mstype is specified](./aggregate-minvfunc-must-be-specified-when-mstype-is-specified.md)
- [array_agg_transfn called in non-aggregate context](./array-agg-transfn-called-in-non-aggregate-context.md)
