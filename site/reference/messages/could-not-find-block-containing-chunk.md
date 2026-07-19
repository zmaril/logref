---
message: "could not find block containing chunk %p"
slug: could-not-find-block-containing-chunk
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/aset.c:1125"
  - "postgres/src/backend/utils/mmgr/aset.c:1267"
  - "postgres/src/backend/utils/mmgr/generation.c:740"
  - "postgres/src/backend/utils/mmgr/generation.c:854"
  - "postgres/src/backend/utils/mmgr/slab.c:887"
reproduced: false
---

# `could not find block containing chunk %p`

## What it means

Internal error. The memory allocator (`aset`) was handed a chunk pointer that does not fall within any block it manages, so it cannot find the owning block to free or resize it. The placeholder is the chunk pointer. It is a heap-integrity check inside the allocator.

## When it happens

It should never occur in a correct build. Reaching it means a pointer was freed twice, a wild/dangling pointer was passed to `pfree`/`repalloc`, or memory was corrupted — typically a C bug in the backend or an extension.

## How to fix

Treat it as an internal bug, usually memory corruption. If it correlates with a specific extension, suspect that extension's memory handling. Capture a stack trace, and run hardware/memory diagnostics if it appears alongside other corruption symptoms.

## Example

*Illustrative* — emitted internally by the allocator.

```text
ERROR:  could not find block containing chunk 0x5590a1b2c3d4
```

## Related

- [is not supported by the bump memory allocator](./is-not-supported-by-the-bump-memory-allocator.md)
- [invalid tuplestore state](./invalid-tuplestore-state.md)
