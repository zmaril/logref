---
message: "libnuma initialization failed or NUMA is not supported on this platform"
slug: libnuma-initialization-failed-or-numa-is-not-supported-on-this-platform
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:305"
  - "postgres/src/backend/storage/ipc/shmem.c:1122"
reproduced: false
---

# `libnuma initialization failed or NUMA is not supported on this platform`

## What it means

A NUMA-related feature could not initialize the `libnuma` library, either because NUMA support is absent on this platform or initialization failed at runtime.

## When it happens

It arises when a NUMA-aware setting or observation function is used on a build or host without working NUMA support — for example querying NUMA memory placement where `libnuma` is unavailable.

## How to fix

Confirm the platform supports NUMA and that `libnuma` is installed and functional, or avoid the NUMA-dependent feature on hosts that lack it. On systems without NUMA, treat this as informational: the feature simply is not available there.

## Example

*Illustrative* — NUMA support missing on the host.

```text
ERROR:  libnuma initialization failed or NUMA is not supported on this platform
```

## Related

- [LZ4 is not supported by this build](./lz4-is-not-supported-by-this-build.md)
- [invalid processing mode in background worker](./invalid-processing-mode-in-background-worker.md)
