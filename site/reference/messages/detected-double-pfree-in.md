---
message: "detected double pfree in %s %p"
slug: detected-double-pfree-in
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/aset.c:1195"
  - "postgres/src/backend/utils/mmgr/generation.c:768"
  - "postgres/src/backend/utils/mmgr/slab.c:755"
reproduced: false
---

# `detected double pfree in %s %p`

## What it means

Internal error. The memory allocator detected that a chunk of memory was freed twice. The placeholders name the context and the chunk pointer. `pfree` on already-freed memory is a serious memory-management bug the allocator catches defensively.

## When it happens

It does not arise from ordinary SQL. It indicates a bug in C code — a core code path, an extension, or a procedural language — that frees the same allocation twice, rather than anything in your data or query.

## How to fix

Treat it as an internal bug. If it appears only when a particular extension or custom C function is loaded, suspect that module and confirm it was built for this server version. Capture the operation and a stack trace and report it.

## Example

*Illustrative* — emitted internally by the memory allocator.

```text
ERROR:  detected double pfree in ExprContext 0x...
```

## Related

- [failed to release reserved memory region addr error code](./failed-to-release-reserved-memory-region-addr-error-code.md)
- [out of memory](./out-of-memory-0fea34.md)
