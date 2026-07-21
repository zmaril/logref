---
message: "failed NUMA pages inquiry status: %m"
slug: failed-numa-pages-inquiry-status
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/shmem.c:1208"
reproduced: false
---

# `failed NUMA pages inquiry status: %m`

## What it means

The shared-memory NUMA reporting path queried the operating system for the NUMA-node status of memory pages and the call failed. The placeholder is the operating-system error. It concerns NUMA observability.

## When it happens

It fires from the server's NUMA status reporting (for example shared-memory NUMA views) when the underlying system call returns an error, typically on platforms or kernels where NUMA inquiry is unsupported or restricted.

## How to fix

Check the operating-system error at the end. NUMA status reporting requires a supporting platform, kernel, and privileges; where NUMA is unavailable the data cannot be gathered. Ignore it if you do not rely on NUMA reporting; otherwise confirm the host's NUMA capabilities and permissions.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed NUMA pages inquiry status: Operation not supported
```

## Related

- [failed NUMA pages inquiry](./failed-numa-pages-inquiry.md)
- [exceeded maxAllocatedDescs while trying to open directory](./exceeded-maxallocateddescs-while-trying-to-open-directory.md)
