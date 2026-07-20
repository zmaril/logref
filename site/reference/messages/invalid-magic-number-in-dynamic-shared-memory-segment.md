---
message: "invalid magic number in dynamic shared memory segment"
slug: invalid-magic-number-in-dynamic-shared-memory-segment
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/parallel.c:1359"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:913"
reproduced: false
---

# `invalid magic number in dynamic shared memory segment`

## What it means

Internal error. When attaching to a dynamic shared memory (DSM) segment, the server found a header magic number that does not match the expected value. It is a consistency guard over DSM segments used by parallel query and extensions.

## When it happens

It fires when a backend attaches a DSM segment whose contents are not a valid DSM header — usually stale segment reuse, an extension that misuses DSM, or memory corruption. Ordinary queries do not surface it.

## How to fix

This is a can't-happen guard. If parallel query triggers it, disabling parallelism (`SET max_parallel_workers_per_gather = 0`) is a workaround. If an extension manages shared memory, suspect it. Capture the workload and report a reproducible case; check host memory if other corruption appears.

## Example

*Illustrative* — a DSM segment with a bad magic number.

```text
ERROR:  invalid magic number in dynamic shared memory segment
```

## Related

- [invalid size for shared memory request for](./invalid-size-for-shared-memory-request-for.md)
- [maximum number of tranches already registered](./maximum-number-of-tranches-already-registered.md)
