---
message: "not enough space to serialize GUC state"
slug: not-enough-space-to-serialize-guc-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:5892"
  - "postgres/src/backend/utils/misc/guc.c:5906"
  - "postgres/src/backend/utils/misc/guc.c:5919"
reproduced: false
---

# `not enough space to serialize GUC state`

## What it means

Internal error. When a parallel worker is launched, the leader serializes the current configuration settings into a shared-memory area for the worker to read. The pre-computed size of that area turned out to be too small.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency between the estimated and actual size of the serialized settings, not to anything you configured directly.

## How to fix

Treat it as an internal bug. Note any unusually large configuration values in effect when it appeared, capture the surrounding context, and report it. Reducing very large custom configuration settings may work around it, but the size estimate is the underlying issue.

## Example

*Illustrative* — raised while launching parallel workers.

```text
ERROR:  not enough space to serialize GUC state
```

## Related

- [parameter cannot be set during a parallel operation](./parameter-cannot-be-set-during-a-parallel-operation.md)
- [too many lwlocks taken](./too-many-lwlocks-taken.md)
