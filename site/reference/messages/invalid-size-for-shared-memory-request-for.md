---
message: "invalid size %zd for shared memory request for \"%s\""
slug: invalid-size-for-shared-memory-request-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/shmem.c:347"
  - "postgres/src/backend/storage/ipc/shmem.c:355"
reproduced: false
---

# `invalid size %zd for shared memory request for "%s"`

## What it means

Internal error. Code requested a shared-memory allocation with a size that is not valid (zero or out of range) for a named region. The placeholders are the size and the region name. It is a consistency guard in the shared-memory allocator.

## When it happens

It fires during shared-memory setup, typically at startup or when an extension reserves shared memory with a bad computed size. Ordinary SQL does not surface it; it points to an extension bug or an internal inconsistency.

## How to fix

This is a can't-happen guard for normal operation. If an extension requests shared memory (via `shmem_request_hook`), review its size computation. Otherwise capture the configuration and report a reproducible case.

## Example

*Illustrative* — a bad shared-memory request size.

```text
ERROR:  invalid size 0 for shared memory request for "my_ext"
```

## Related

- [invalid magic number in dynamic shared memory segment](./invalid-magic-number-in-dynamic-shared-memory-segment.md)
- [maximum number of tranches already registered](./maximum-number-of-tranches-already-registered.md)
