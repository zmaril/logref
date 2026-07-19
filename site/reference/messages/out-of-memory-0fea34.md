---
message: "out of memory\n"
slug: out-of-memory-0fea34
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/backend/utils/misc/ps_status.c:206"
  - "postgres/src/backend/utils/misc/ps_status.c:214"
  - "postgres/src/backend/utils/misc/ps_status.c:247"
  - "postgres/src/backend/utils/misc/ps_status.c:255"
reproduced: false
---

# `out of memory
`

## What it means

A component wrote a bare `out of memory` line to stderr because a memory allocation failed at a point where the normal error path was not available. The severity varies by call site. It means the process could not obtain memory from the operating system for the work it was doing.

## When it happens

Genuine memory exhaustion — an over-large `work_mem`/`maintenance_work_mem` for the concurrency in play, a query building huge in-memory structures, a memory leak, or the OS/cgroup memory limit being reached (possibly with the OOM killer involved).

## Is this a problem?

Reduce memory demand: lower `work_mem`/`maintenance_work_mem`, cut the number of concurrent memory-hungry queries, and check for a query materializing far more than expected. At the OS level, ensure adequate RAM/swap and appropriate cgroup limits, and check for the OOM killer in the kernel log. If a specific statement reproduces it, examine its plan for an unexpected in-memory operation.

## Example

*Illustrative* — an allocation failure written to stderr.

```text
out of memory
```

## Related

- [out of memory while allocating a WAL reading processor](./out-of-memory-while-allocating-a-wal-reading-processor.md)
- [out of file descriptors: release and retry](./out-of-file-descriptors-release-and-retry.md)
