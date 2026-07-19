---
message: "too many registered buffers"
slug: too-many-registered-buffers
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xloginsert.c:275"
  - "postgres/src/backend/access/transam/xloginsert.c:328"
reproduced: false
---

# `too many registered buffers`

## What it means

Internal error. Code that pins and tracks buffers registered more than the fixed maximum a single operation may hold at once. It is a safety limit on simultaneously registered buffers.

## When it happens

It fires from buffer-management paths (for example WAL insertion or an access method) that register multiple buffers per operation when the count exceeds the internal cap. Ordinary SQL does not usually reach it directly.

## How to fix

This is an internal limit guard. If a real operation triggers it, it typically points to an access method or extension registering too many buffers; capture the operation and report it.

## Example

*Illustrative* — exceeding the registered-buffer limit.

```text
ERROR:  too many registered buffers
```

## Related

- [ResourceOwnerForget called for %s after release started](./resourceownerforget-called-for-after-release-started.md)
- [out of shared memory (%zu bytes requested)](./out-of-shared-memory-bytes-requested.md)
