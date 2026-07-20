---
message: "could not duplicate handle for \"%s\": %m"
slug: could-not-duplicate-handle-for
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:983"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:1032"
reproduced: false
---

# `could not duplicate handle for "%s": %m`

## What it means

The dynamic-shared-memory implementation could not duplicate an OS handle for sharing with another process. The placeholders are the object name and the system reason. Passing shared-memory or file handles between backends failed at the OS level.

## When it happens

Setting up dynamic shared memory for parallel query or other cross-process features when the OS refuses to duplicate the handle — often a resource limit, a permission issue, or a platform-specific fault.

## How to fix

Check the OS error in the detail. On resource-limit failures, raise the relevant limits (file descriptors, handles); investigate platform-specific constraints otherwise. As a workaround, reducing parallelism lowers demand for shared-memory handles. Report persistent cases with the OS detail.

## Example

*Illustrative* — a handle that could not be duplicated.

```text
ERROR:  could not duplicate handle for "dsm segment": Too many open files
```

## Related

- [could not create pipe for syslog](./could-not-create-pipe-for-syslog.md)
- [cannot wait on a latch owned by another process](./cannot-wait-on-a-latch-owned-by-another-process.md)
