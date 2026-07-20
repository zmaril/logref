---
message: "deserialfunc not provided for deserialization aggregation"
slug: deserialfunc-not-provided-for-deserialization-aggregation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:3839"
reproduced: false
---

# `deserialfunc not provided for deserialization aggregation`

## What it means

An internal executor guard. A parallel or partial aggregate needed to deserialize a transition value, but the aggregate has no deserialization function registered. This should not occur for a correctly defined aggregate.

## When it happens

It fires in the aggregate executor when combining partial aggregation results requires a `deserialfunc` that the aggregate's catalog definition does not supply.

## How to fix

This is not a user query error. If it involves a custom aggregate, its definition is inconsistent: an aggregate that supplies a serialization function must also supply a matching `DESERIALFUNC`. Fix the `CREATE AGGREGATE`. For built-in aggregates, capture the case and report it.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  deserialfunc not provided for deserialization aggregation
```

## Related

- [DISTINCT is not implemented for window functions](./distinct-is-not-implemented-for-window-functions.md)
- [do_numeric_discard failed unexpectedly](./do-numeric-discard-failed-unexpectedly.md)
