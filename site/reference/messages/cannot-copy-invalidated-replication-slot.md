---
message: "cannot copy invalidated replication slot \"%s\""
slug: cannot-copy-invalidated-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:714"
reproduced: false
---

# `cannot copy invalidated replication slot "%s"`

## What it means

A slot-copy function named a source slot that has been invalidated — for example one dropped by exceeding `max_slot_wal_keep_size`. An invalidated slot no longer holds a usable position, so it cannot be copied. The placeholder is the slot name.

## When it happens

It occurs when copying a replication slot whose `conflicting`/invalidated state means it can no longer stream.

## How to fix

Create a fresh slot rather than copying an invalidated one. Address the cause of invalidation — such as insufficient retained WAL — before relying on the slot again.

## Example

*Illustrative* — copying an invalidated slot.

```text
ERROR:  cannot copy invalidated replication slot "s"
```

## Related

- [cannot copy replication slot](./cannot-copy-replication-slot.md)
- [cannot copy a replication slot that doesn't reserve wal](./cannot-copy-a-replication-slot-that-doesn-t-reserve-wal.md)
