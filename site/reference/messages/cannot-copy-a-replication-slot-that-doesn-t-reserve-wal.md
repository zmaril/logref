---
message: "cannot copy a replication slot that doesn't reserve WAL"
slug: cannot-copy-a-replication-slot-that-doesn-t-reserve-wal
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:708"
reproduced: false
---

# `cannot copy a replication slot that doesn't reserve WAL`

## What it means

A `pg_copy_logical_replication_slot` or `pg_copy_physical_replication_slot` call named a source slot that does not reserve write-ahead log. A slot must have a reserved WAL position to be copied, since the copy inherits that position. The placeholder is the slot name.

## When it happens

It occurs when copying a slot that was created without reserving WAL, so it has no restart position to duplicate.

## How to fix

Copy only slots that reserve WAL. Create the source slot with WAL reservation (for physical slots, pass the reserve-WAL option), or reserve it before copying.

## Example

*Illustrative* — copying a non-reserving slot.

```text
ERROR:  cannot copy a replication slot that doesn't reserve WAL
```

## Related

- [cannot copy replication slot](./cannot-copy-replication-slot.md)
- [cannot copy invalidated replication slot](./cannot-copy-invalidated-replication-slot.md)
