---
message: "cannot assign TransactionIds during a parallel operation"
slug: cannot-assign-transactionids-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:78"
reproduced: false
---

# `cannot assign TransactionIds during a parallel operation`

## What it means

A low-level guard in the transaction-ID allocator: it was called to hand out a new XID while a parallel operation was active. Parallel workers run under the leader's transaction and may not begin their own writing transaction.

## When it happens

It is reached from the same situation as the higher-level parallel-write check, when code that needs an XID executes inside a parallel worker or leader region.

## How to fix

Keep writes out of parallel-executed code. Mark writing functions `PARALLEL UNSAFE`, or move the write outside the parallel query so no worker needs to allocate a transaction ID.

## Example

*Illustrative* — XID allocation during a parallel operation.

```text
ERROR:  cannot assign TransactionIds during a parallel operation
```

## Related

- [cannot assign transaction ids during a parallel operation](./cannot-assign-transaction-ids-during-a-parallel-operation.md)
- [cannot assign transactionids during recovery](./cannot-assign-transactionids-during-recovery.md)
