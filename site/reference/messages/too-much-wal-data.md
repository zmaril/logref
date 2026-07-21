---
message: "too much WAL data"
slug: too-much-wal-data
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xloginsert.c:379"
  - "postgres/src/backend/access/transam/xloginsert.c:433"
  - "postgres/src/backend/access/transam/xloginsert.c:438"
  - "postgres/src/backend/access/transam/xloginsert.c:947"
reproduced: false
---

# `too much WAL data`

## What it means

Internal error. Assembling a single WAL record, the server tried to include more data than one record may hold. WAL records have a maximum size; code that registers buffers and data for a record is expected to stay within it, so overflowing is a consistency check.

## When it happens

It does not arise from ordinary transactions. It points to a bug in the code path that constructs a particular WAL record — often a custom `rmgr` or an operation registering an unexpected amount of data — rather than to workload size.

## How to fix

Treat it as an internal bug. If it correlates with a specific extension that emits custom WAL, suspect that extension. Capture the operation in progress and report it with a reproducer.

## Example

*Illustrative* — emitted internally while building a WAL record.

```text
ERROR:  too much WAL data
```

## Related

- [out of memory while allocating a WAL reading processor](./out-of-memory-while-allocating-a-wal-reading-processor.md)
- [failed to register custom resource manager with id](./failed-to-register-custom-resource-manager-with-id.md)
