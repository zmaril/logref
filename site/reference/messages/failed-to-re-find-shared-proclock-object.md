---
message: "failed to re-find shared proclock object"
slug: failed-to-re-find-shared-proclock-object
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:2271"
  - "postgres/src/backend/storage/lmgr/lock.c:3050"
  - "postgres/src/backend/storage/lmgr/lock.c:3334"
reproduced: false
---

# `failed to re-find shared proclock object`

## What it means

Internal error. The lock manager tried to re-locate a per-process lock (`PROCLOCK`) object in shared memory and could not find it. The placeholder-free message is a consistency check pairing a process with its held locks; the object should still exist.

## When it happens

It does not arise from ordinary SQL. Like its lock-object sibling, it indicates shared-memory lock-table inconsistency or corruption, and at some sites is a `PANIC`.

## How to fix

Treat it as an internal bug or shared-memory corruption. Capture the surrounding server log and report it. Recurrences warrant checking the host memory; a `PANIC` restarts the cluster to restore a consistent lock table.

## Example

*Illustrative* — emitted internally by the lock manager.

```text
PANIC:  failed to re-find shared proclock object
```

## Related

- [failed to re-find shared lock object](./failed-to-re-find-shared-lock-object.md)
- [unrecognized lock mode](./unrecognized-lock-mode.md)
