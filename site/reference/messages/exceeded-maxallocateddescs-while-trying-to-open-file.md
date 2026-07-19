---
message: "exceeded maxAllocatedDescs (%d) while trying to open file \"%s\""
slug: exceeded-maxallocateddescs-while-trying-to-open-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2637"
  - "postgres/src/backend/storage/file/fd.c:2696"
reproduced: false
---

# `exceeded maxAllocatedDescs (%d) while trying to open file "%s"`

## What it means

The server hit its internal limit on simultaneously tracked file descriptors while opening a file. The `%d` is the limit and the `%s` is the file. A single backend operation asked for too many open descriptors at once.

## When it happens

An operation that opens many files concurrently — a large query touching many partitions or tablespaces, or an extension that leaks descriptors — exceeded the tracked-descriptor cap.

## How to fix

Reduce how many files the operation opens at once (fewer partitions scanned together, or simpler queries). If an extension leaks descriptors, suspect it. This is a per-operation cap, distinct from the OS limit.

## Example

*Illustrative* — too many concurrently opened files.

```text
ERROR:  exceeded maxAllocatedDescs (128) while trying to open file "base/16384/16390"
```

## Related

- [could not open temporary file](./could-not-open-temporary-file.md)
- [getrlimit failed](./getrlimit-failed.md)
