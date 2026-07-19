---
message: "detected realloc of freed chunk in %s %p"
slug: detected-realloc-of-freed-chunk-in
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/aset.c:1398"
  - "postgres/src/backend/utils/mmgr/generation.c:878"
reproduced: false
---

# `detected realloc of freed chunk in %s %p`

## What it means

Internal error in the memory-context allocator. A `repalloc` was called on a chunk that had already been freed. The `%s` and `%p` identify the context and address. It is a memory-safety guard that catches a use-after-free.

## When it happens

It signals a bug — in core code or, more often, in an extension or a C function — that reallocates memory it already released. It does not come from SQL or data.

## How to fix

This points at a coding defect in whatever C code touched that memory. If an extension or custom function is loaded, suspect it first. Capture the context name and a reproduction and report it.

## Example

*Illustrative* — a realloc of already-freed memory.

```text
ERROR:  detected realloc of freed chunk in ExprContext 0x5601a2
```

## Related

- [doubly linked list is corrupted](./doubly-linked-list-is-corrupted.md)
- [free page manager btree is corrupt](./free-page-manager-btree-is-corrupt.md)
