---
message: "could not expand integer set, maximum number of levels reached"
slug: could-not-expand-integer-set-maximum-number-of-levels-reached
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/integerset.c:497"
reproduced: false
---

# `could not expand integer set, maximum number of levels reached`

## What it means

An internal compressed integer-set structure reached its maximum tree depth and could not grow further. Integer sets back structures such as TID stores used during index builds and vacuum.

## When it happens

It fires from the integer-set library when it cannot add another level to hold more entries. It is an internal limit that ordinary workloads do not reach.

## How to fix

This is an internal error. If it appears, note the operation that triggered it (typically a very large index build or vacuum) and report a reproducible case. There is no user-facing setting for it.

## Example

*Illustrative* — the integer set hitting its depth limit.

```text
ERROR:  could not expand integer set, maximum number of levels reached
```

## Related

- [could not find memoization table entry](./could-not-find-memoization-table-entry.md)
- [could not find a feasible split point for index](./could-not-find-a-feasible-split-point-for-index.md)
