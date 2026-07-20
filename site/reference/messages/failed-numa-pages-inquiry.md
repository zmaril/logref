---
message: "failed NUMA pages inquiry: %m"
slug: failed-numa-pages-inquiry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:380"
reproduced: false
---

# `failed NUMA pages inquiry: %m`

## What it means

The `pg_buffercache` NUMA reporting path asked the operating system which NUMA node each shared-buffer page lives on, and the inquiry failed. The placeholder is the operating-system error. It concerns NUMA observability, not data correctness.

## When it happens

It fires from `pg_buffercache`'s NUMA view when the underlying system call (querying page NUMA placement) returns an error — for example on a kernel or platform where the interface is unavailable or restricted.

## How to fix

Read the trailing operating-system error. NUMA page inquiry needs a platform and kernel that support it and sufficient privileges; on systems without NUMA support the information is simply not available. If you do not need NUMA placement data, ignore the view. Otherwise verify the host's NUMA support and permissions.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed NUMA pages inquiry: Operation not supported
```

## Related

- [failed NUMA pages inquiry status](./failed-numa-pages-inquiry-status.md)
- [exceeded maxAllocatedDescs while trying to open directory](./exceeded-maxallocateddescs-while-trying-to-open-directory.md)
