---
message: "failed to re-find shared lock object"
slug: failed-to-re-find-shared-lock-object
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:2261"
  - "postgres/src/backend/storage/lmgr/lock.c:3037"
  - "postgres/src/backend/storage/lmgr/lock.c:3318"
reproduced: false
---

# `failed to re-find shared lock object`

## What it means

Internal error. The lock manager tried to re-locate a shared lock object in its shared-memory hash table and could not find it. The placeholder-free message is a consistency check on the lock table; the object should still be present because the process holds a reference to it.

## When it happens

It does not arise from ordinary SQL. It points to shared-memory lock-table inconsistency or corruption — a serious internal condition — and at some sites is severe enough to be a `PANIC`.

## How to fix

Treat it as an internal bug or shared-memory corruption. Capture the server log around the event (including any preceding errors) and report it. If it recurs, check the host for memory faults; a `PANIC` here will restart the cluster to restore consistency.

## Example

*Illustrative* — emitted internally by the lock manager.

```text
PANIC:  failed to re-find shared lock object
```

## Related

- [failed to re-find shared proclock object](./failed-to-re-find-shared-proclock-object.md)
- [unrecognized lock mode](./unrecognized-lock-mode.md)
