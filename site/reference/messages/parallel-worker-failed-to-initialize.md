---
message: "parallel worker failed to initialize"
slug: parallel-worker-failed-to-initialize
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/parallel.c:759"
  - "postgres/src/backend/access/transam/parallel.c:878"
reproduced: false
---

# `parallel worker failed to initialize`

## What it means

A parallel worker process started but could not complete the setup needed to join its leader's parallel operation, so the parallel execution cannot proceed with it.

## When it happens

It surfaces when a launched parallel worker fails during initialization — commonly because it could not attach the shared state, ran into a resource limit, or the leader's environment could not be restored in the worker.

## How to fix

Check the server log around the failure for the underlying cause (out-of-memory, shared-memory limits, or an extension that mis-handles parallel setup). Reducing parallelism (`max_parallel_workers_per_gather`, or `SET max_parallel_workers_per_gather = 0` for the query) lets the work run serially while you address the root cause.

## Example

*Illustrative* — a parallel worker that could not finish setup.

```text
ERROR:  parallel worker failed to initialize
HINT:  More details may be available in the server log.
```

## Related

- [out of background worker slots](./out-of-background-worker-slots.md)
- [perhaps the backend died while processing](./perhaps-the-backend-died-while-processing.md)
