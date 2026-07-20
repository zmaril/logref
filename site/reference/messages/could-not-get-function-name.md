---
message: "could not get function name"
slug: could-not-get-function-name
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3661"
reproduced: false
---

# `could not get function name`

## What it means

The window-function executor tried to read the name of a window function it was about to run and could not. It resolves the function's name to route the call to the right support routine.

## When it happens

It fires while executing a query with window functions, when the executor cannot resolve a window function's name from its catalog entry — an internal inconsistency rather than a user-facing condition.

## How to fix

This is an internal guard. It should not be reachable on stock catalogs; a custom window function registered inconsistently, or catalog damage, could produce it. If a custom function is involved, check its definition; otherwise capture the query and report a reproducible case.

## Example

*Illustrative* — a window function whose name could not be read.

```text
ERROR:  could not get function name
```

## Related

- [could not identify ctid operator](./could-not-identify-ctid-operator.md)
- [could not implement window order by](./could-not-implement-window-order-by.md)
