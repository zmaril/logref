---
message: "unrecognized lock method: %d"
slug: unrecognized-lock-method
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:705"
  - "postgres/src/backend/storage/lmgr/lock.c:856"
  - "postgres/src/backend/storage/lmgr/lock.c:2122"
  - "postgres/src/backend/storage/lmgr/lock.c:2327"
  - "postgres/src/backend/storage/lmgr/lock.c:2595"
  - "postgres/src/backend/storage/lmgr/lock.c:3092"
  - "postgres/src/backend/storage/lmgr/lock.c:4363"
  - "postgres/src/backend/storage/lmgr/lock.c:4534"
  - "postgres/src/backend/storage/lmgr/lock.c:4566"
  - "postgres/src/backend/storage/lmgr/lock.c:4846"
reproduced: false
---

# `unrecognized lock method: %d`

## What it means

Internal error. The lock manager was given a lock-method identifier that is neither the default nor the user (advisory) lock method. The placeholder is the numeric method. Only two lock methods exist; any other value indicates a bug or memory corruption.

## When it happens

A bug in core or an extension calling the lock-manager API with a bad method id, or memory corruption. Ordinary locking does not trigger it.

## How to fix

Treat it as a bug. If an extension takes locks via internal APIs, suspect it. Capture the workload and a stack trace and report it. If accompanied by other corruption symptoms, check hardware/memory.

## Example

*Illustrative* — an internal lock-manager guard firing.

```text
ERROR:  unrecognized lock method: 3
```

## Related

- [out of shared memory](./out-of-shared-memory.md)
- [unrecognized node type](./unrecognized-node-type.md)
