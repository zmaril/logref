---
message: "BitmapOr doesn't support zero inputs"
slug: bitmapor-doesn-t-support-zero-inputs
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapOr.c:181"
reproduced: false
---

# `BitmapOr doesn't support zero inputs`

## What it means

A bitmap-OR plan node was constructed with no input plans. A bitmap-OR unions two or more bitmap sources, so an empty input list is invalid.

## When it happens

It is an internal planner or executor consistency check that does not arise from ordinary queries.

## How to fix

This is not user-fixable. If a plain query produced it, capture the query and `EXPLAIN` output and report it as a possible planner bug, noting any relevant extensions.

## Example

*Illustrative* — the zero-input guard.

```text
ERROR:  BitmapOr doesn't support zero inputs
```

## Related

- [bitmapand doesn't support zero inputs](./bitmapand-doesn-t-support-zero-inputs.md)
- [bitmapor node does not support execprocnode call convention](./bitmapor-node-does-not-support-execprocnode-call-convention.md)
