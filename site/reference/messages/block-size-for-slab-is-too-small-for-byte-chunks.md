---
message: "block size %zu for slab is too small for %zu-byte chunks"
slug: block-size-for-slab-is-too-small-for-byte-chunks
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/slab.c:359"
reproduced: false
---

# `block size %zu for slab is too small for %zu-byte chunks`

## What it means

A slab memory allocator was created with a block size too small to hold even one chunk of the requested size. The placeholders are the block size and the chunk size. Each slab block must fit at least one chunk plus overhead. It is an internal setup check.

## When it happens

It is a programming-level guard hit when a slab context is configured with mismatched block and chunk sizes, typically inside an extension that creates its own memory contexts.

## How to fix

This is not caused by SQL. If it comes from an extension, the extension's slab-context parameters are wrong; report it to the extension author. In core code it indicates a bug worth reporting with the server version.

## Example

*Illustrative* — a slab block too small for its chunk.

```text
ERROR:  block size 64 for slab is too small for 128-byte chunks
```

## Related

- [bit width must be between 4 and 16 inclusive](./bit-width-must-be-between-4-and-16-inclusive.md)
- [bitmapset overflow](./bitmapset-overflow.md)
