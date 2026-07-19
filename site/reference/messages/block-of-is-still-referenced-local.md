---
message: "block %u of %s is still referenced (local %d)"
slug: block-of-is-still-referenced-local
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/buffer/localbuf.c:658"
reproduced: false
---

# `block %u of %s is still referenced (local %d)`

## What it means

The buffer manager tried to drop or invalidate a buffer that still has outstanding local pin references. The placeholders are the block number, the relation fork, and the local pin count. A buffer cannot be discarded while it is pinned. It is an internal invariant.

## When it happens

It is a can't-happen guard in buffer management. It would surface from a bug that leaks buffer pins, not from ordinary SQL.

## How to fix

There is no user action. If it appears, note any extensions that access buffers directly and capture the surrounding log, then report it as a possible bug with the server version.

## Example

*Illustrative* — a pinned buffer being dropped.

```text
ERROR:  block 42 of base/16384/12345 is still referenced (local 1)
```

## Related

- [attempted to update invisible tuple](./attempted-to-update-invisible-tuple.md)
- [bitmapset overflow](./bitmapset-overflow.md)
