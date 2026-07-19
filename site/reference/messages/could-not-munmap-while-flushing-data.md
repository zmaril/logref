---
message: "could not munmap() while flushing data: %m"
slug: could-not-munmap-while-flushing-data
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:664"
reproduced: false
---

# `could not munmap() while flushing data: %m`

## What it means

The server tried to release a memory-mapped region it had used to flush data to disk and the `munmap` call failed. The `%m` reason gives the cause. On some platforms the server maps a file to force its dirty pages out.

## When it happens

It fires at the highest severity while flushing data via a memory mapping, when unmapping the region fails — an unusual operating-system-level failure, sometimes tied to memory or mapping-limit problems.

## How to fix

This is a low-level operating-system failure during a flush. Check the host for memory pressure and for limits on the number of memory mappings, and review the `%m` reason. The server will restart; if it recurs on a healthy host, capture the log and report it.

## Example

*Illustrative* — a mapping could not be released after flushing.

```text
FATAL:  could not munmap() while flushing data: Invalid argument
```

## Related

- [could not map anonymous shared memory](./could-not-map-anonymous-shared-memory.md)
- [could not open file (target block)](./could-not-open-file-target-block.md)
