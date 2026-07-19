---
message: "cannot assign TransactionIds during recovery"
slug: cannot-assign-transactionids-during-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:94"
reproduced: false
---

# `cannot assign TransactionIds during recovery`

## What it means

A low-level guard in the transaction-ID allocator: it was called to hand out a new XID while the server was in recovery. Only a system replaying its own write-ahead log advances the XID counter, so allocation during WAL replay is forbidden.

## When it happens

It is reached when an operation that would write, and therefore need an XID, runs on a standby or during crash recovery. Read-only work is normally rejected earlier.

## How to fix

Do not attempt writes on a standby or before recovery completes. If it fires from normal use, capture the statement and recovery state, since reaching this guard suggests a deeper issue than a plain read-only rejection.

## Example

*Illustrative* — XID allocation during recovery.

```text
ERROR:  cannot assign TransactionIds during recovery
```

## Related

- [cannot assign oids during recovery](./cannot-assign-oids-during-recovery.md)
- [cannot assign multixactids during recovery](./cannot-assign-multixactids-during-recovery.md)
