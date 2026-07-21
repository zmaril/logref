---
message: "ResourceOwnerForget called for %s after release started"
slug: resourceownerforget-called-for-after-release-started
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/resowner/resowner.c:579"
  - "postgres/src/backend/utils/resowner/resowner.c:829"
reproduced: false
---

# `ResourceOwnerForget called for %s after release started`

## What it means

Internal error. A resource (buffer pin, lock, tuple descriptor, and so on) was being deregistered from its ResourceOwner after that owner had already begun releasing its resources. The placeholder names the resource kind. The release ordering was violated.

## When it happens

It fires from the resource-owner subsystem when `ResourceOwnerForget` runs during or after teardown of the owner — typically a bug in code that holds a resource past the point it should have released it.

## How to fix

This is an internal invariant guard. If reproducible, capture the operation (often an extension or a specific function) that holds the resource and report it; the ordering fault is in code, not configuration.

## Example

*Illustrative* — forgetting a resource after release began.

```text
ERROR:  ResourceOwnerForget called for buffer after release started
```

## Related

- [too many registered buffers](./too-many-registered-buffers.md)
- [trying to store an on-disk heap tuple into wrong type of slot](./trying-to-store-an-on-disk-heap-tuple-into-wrong-type-of-slot.md)
