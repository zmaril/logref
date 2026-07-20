---
message: "cannot create logical replication slot in transaction that has performed writes"
slug: cannot-create-logical-replication-slot-in-transaction-that-has-performed-writes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ACTIVE_SQL_TRANSACTION
    code: "25001"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:368"
reproduced: false
---

# `cannot create logical replication slot in transaction that has performed writes`

## What it means

A logical replication slot was requested inside a transaction that had already written data. Slot creation must establish a consistent snapshot, which cannot be done once the transaction has made changes.

## When it happens

It occurs when calling `pg_create_logical_replication_slot` in a transaction that has already run an `INSERT`, `UPDATE`, or other write.

## How to fix

Create the logical slot in a fresh transaction that has performed no writes — ideally as the first statement after `BEGIN`, or outside an explicit transaction block entirely.

## Example

*Illustrative* — slot creation after a write.

```text
ERROR:  cannot create logical replication slot in transaction that has performed writes
```

## Related

- [cannot copy unfinished logical replication slot](./cannot-copy-unfinished-logical-replication-slot.md)
- [cannot enable subscription that does not have a slot name](./cannot-enable-subscription-that-does-not-have-a-slot-name.md)
