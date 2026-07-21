---
message: "incomplete GUC state"
slug: incomplete-guc-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:6047"
  - "postgres/src/backend/utils/misc/guc.c:6067"
reproduced: false
---

# `incomplete GUC state`

## What it means

Internal error. Code restoring serialized GUC (configuration) state for a parallel worker found it truncated. It is a consistency guard on the parallel-worker state transfer.

## When it happens

It fires when a parallel worker's serialized GUC snapshot did not contain all expected data. Ordinary parallel queries do not surface it; it indicates an internal inconsistency.

## How to fix

This is a can't-happen guard. As a workaround, disabling parallelism (`SET max_parallel_workers_per_gather = 0`) avoids the transfer. Capture the query and report a reproducible case.

## Example

*Illustrative* — truncated GUC state for a parallel worker.

```text
ERROR:  incomplete GUC state
```

## Related

- [incomplete Bitmapset structure](./incomplete-bitmapset-structure.md)
- [incomplete scalar array](./incomplete-scalar-array.md)
