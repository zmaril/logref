---
message: "BitmapAnd doesn't support zero inputs"
slug: bitmapand-doesn-t-support-zero-inputs
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapAnd.c:163"
reproduced: false
---

# `BitmapAnd doesn't support zero inputs`

## What it means

A bitmap-AND plan node was constructed with no input plans. A bitmap-AND combines two or more bitmap sources, so an empty input list is invalid.

## When it happens

It is an internal planner or executor consistency check. It would only appear from a bug in plan construction, not from writing a query.

## How to fix

This is not a user-facing condition. If a normal query triggered it, capture the query and `EXPLAIN` output and report it as a possible planner bug, noting any extensions that add scan or index methods.

## Example

*Illustrative* — the zero-input guard.

```text
ERROR:  BitmapAnd doesn't support zero inputs
```

## Related

- [bitmapor doesn't support zero inputs](./bitmapor-doesn-t-support-zero-inputs.md)
- [bitmapand node does not support execprocnode call convention](./bitmapand-node-does-not-support-execprocnode-call-convention.md)
