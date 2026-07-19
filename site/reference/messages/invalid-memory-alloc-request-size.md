---
message: "invalid memory alloc request size %zu"
slug: invalid-memory-alloc-request-size
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/mcxt.c:1224"
  - "postgres/src/backend/utils/mmgr/mcxt.c:1301"
reproduced: false
---

# `invalid memory alloc request size %zu`

## What it means

Internal error. Code asked the memory allocator for a block whose size is zero or larger than the maximum single allocation Postgres permits (about 1 GB for most contexts). The allocator refuses the request. The placeholder is the requested size.

## When it happens

It fires when a computed length overflows or is unreasonably large — for example a corrupted length field, an over-wide row assembled internally, or an extension miscomputing a size. It can also surface when reading a corrupted datum whose length header is huge.

## How to fix

This is a defensive guard. If a specific value or row triggers it, that data may be corrupt (a bad length header) — locate and repair it, and check storage. If a custom C function computes the size, review its arithmetic for overflow. Capture the statement and report a reproducible case.

## Example

*Illustrative* — an allocation request beyond the allowed maximum.

```text
ERROR:  invalid memory alloc request size 2000000000
```

## Related

- [invalid size for shared memory request for](./invalid-size-for-shared-memory-request-for.md)
- [invalid datum pointer](./invalid-datum-pointer.md)
