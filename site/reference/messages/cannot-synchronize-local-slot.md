---
message: "cannot synchronize local slot \"%s\""
slug: cannot-synchronize-local-slot
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:835"
reproduced: false
---

# `cannot synchronize local slot "%s"`

## What it means

Slot synchronization on a standby tried to synchronize a slot that was created locally rather than mirrored from the primary. Only slots that the primary manages can be kept in sync, so a purely local slot with the same name blocks the operation.

## When it happens

It occurs during replication-slot synchronization on a hot standby when a local slot name collides with one the primary is trying to synchronize.

## How to fix

Drop or rename the conflicting local slot on the standby so synchronization can create and maintain the mirrored slot, then retry.

## Example

*Illustrative* — a local slot blocking sync.

```text
ERROR:  cannot synchronize local slot "my_slot"
```

## Related

- [cannot synchronize replication slots concurrently](./cannot-synchronize-replication-slots-concurrently.md)
- [cannot synchronize replication slots from a standby server](./cannot-synchronize-replication-slots-from-a-standby-server.md)
