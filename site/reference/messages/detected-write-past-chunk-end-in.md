---
message: "detected write past chunk end in %s %p"
slug: detected-write-past-chunk-end-in
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/mmgr/alignedalloc.c:44"
  - "postgres/src/backend/utils/mmgr/aset.c:1134"
  - "postgres/src/backend/utils/mmgr/aset.c:1200"
  - "postgres/src/backend/utils/mmgr/aset.c:1280"
  - "postgres/src/backend/utils/mmgr/aset.c:1403"
  - "postgres/src/backend/utils/mmgr/generation.c:773"
  - "postgres/src/backend/utils/mmgr/generation.c:883"
  - "postgres/src/backend/utils/mmgr/slab.c:760"
reproduced: false
---

# `detected write past chunk end in %s %p`

## What it means

A memory-context sanity check found that code wrote past the end of an allocated chunk — a buffer overrun detected by the allocator's guard bytes. The placeholders are the context and chunk pointer. It is a `WARNING` because it is caught after the fact, but it indicates a real memory-safety bug.

## When it happens

A bug in C code — core or, more often, an extension — that wrote beyond an allocation it requested. The overrun corrupted the allocator's guard region, which the memory context detected when the chunk was freed or checked. Not caused by ordinary SQL data.

## Is this a problem?

Treat it as a serious bug. If you run C extensions, suspect one of them writing out of bounds; disable extensions to isolate which. The corruption may have damaged other memory, so restart the affected backend. Capture the workload and report it to the code's author — buffer overruns can cause crashes and data corruption beyond the warning.

## Example

*Illustrative* — an allocator guard catching an overrun.

```text
WARNING:  detected write past chunk end in ExprContext 0x55e0f2a1b040
```

## Related

- [hash table corrupted](./hash-table-corrupted-ef89f9.md)
- [out of memory](./out-of-memory-6bf5c2.md)
