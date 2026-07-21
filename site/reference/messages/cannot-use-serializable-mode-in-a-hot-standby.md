---
message: "cannot use serializable mode in a hot standby"
slug: cannot-use-serializable-mode-in-a-hot-standby
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/storage/lmgr/predicate.c:1622"
reproduced: false
---

# `cannot use serializable mode in a hot standby`

## What it means

A transaction on a hot standby asked for `SERIALIZABLE` isolation. Serializable isolation depends on predicate locking that only the primary maintains, so it is not available on a read-only standby.

## When it happens

It occurs when a session on a hot standby runs `SET TRANSACTION ISOLATION LEVEL SERIALIZABLE` or has `default_transaction_isolation` set to serializable.

## How to fix

Use `REPEATABLE READ` on the standby, which gives a stable snapshot for read-only work, or run serializable transactions on the primary.

## Example

*Illustrative* — serializable on a standby.

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
-- ERROR:  cannot use serializable mode in a hot standby
```

## Related

- [cannot use a logical replication slot for physical replication](./cannot-use-a-logical-replication-slot-for-physical-replication.md)
- [cannot use](./cannot-use.md)
