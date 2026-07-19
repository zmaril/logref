---
message: "lock table corrupted"
slug: lock-table-corrupted
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:1367"
  - "postgres/src/backend/storage/lmgr/lock.c:1783"
  - "postgres/src/backend/storage/lmgr/lock.c:4445"
reproduced: false
---

# `lock table corrupted`

## What it means

Internal error. The lock manager found its shared lock table in an inconsistent state — a lock's bookkeeping did not add up while releasing or cleaning up. Because a broken lock table threatens correctness for the whole cluster, it is raised at PANIC.

## When it happens

It should not occur in a healthy server. Reaching it points to shared-memory corruption or an internal inconsistency in lock accounting, not to anything in a single query.

## How to fix

Treat it as a serious internal fault. The PANIC restarts the server to rebuild shared memory; after restart, check hardware and memory health, review the logs for a pattern, and capture the surrounding context to report. Repeated occurrences suggest failing memory or a bug worth escalating.

## Example

*Illustrative* — raised by the lock manager.

```text
PANIC:  lock table corrupted
```

## Related

- [too many lwlocks taken](./too-many-lwlocks-taken.md)
- [invalid max offset number](./invalid-max-offset-number.md)
