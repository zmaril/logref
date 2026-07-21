---
message: "unrecognized lock mode: %d"
slug: unrecognized-lock-mode
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:708"
  - "postgres/src/backend/storage/lmgr/lock.c:859"
  - "postgres/src/backend/storage/lmgr/lock.c:2125"
  - "postgres/src/backend/storage/lmgr/lock.c:3095"
reproduced: false
---

# `unrecognized lock mode: %d`

## What it means

Internal error. Lock-manager code was passed a lock mode value outside the defined set. The placeholder is the numeric mode. Lock modes are fixed constants (from `AccessShareLock` through `AccessExclusiveLock`); a value outside that range means a caller passed a bad constant.

## When it happens

It does not arise from ordinary SQL. It points to a bug in code that requests locks — often an extension passing an invalid lock mode — rather than to anything a user does.

## How to fix

Treat it as an internal bug. If it appears only with a particular extension, suspect that extension and confirm it was built for this server version. Capture the operation and report it.

## Example

*Illustrative* — emitted internally by the lock manager.

```text
ERROR:  unrecognized lock mode: 99
```

## Related

- [unrecognized table_tuple_lock status](./unrecognized-table-tuple-lock-status.md)
- [failed to re-find shared lock object](./failed-to-re-find-shared-lock-object.md)
