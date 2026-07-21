---
message: "maximum number of prepared transactions reached"
slug: maximum-number-of-prepared-transactions-reached
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:408"
  - "postgres/src/backend/access/transam/twophase.c:2581"
reproduced: false
---

# `maximum number of prepared transactions reached`

## What it means

A `PREPARE TRANSACTION` could not proceed because the pool of prepared-transaction slots is full. The number of slots is fixed by `max_prepared_transactions`.

## When it happens

It arises when two-phase commit is in heavy use, or when prepared transactions are left dangling (prepared but never committed or rolled back) and accumulate until the slots are exhausted.

## How to fix

Resolve dangling prepared transactions: inspect `pg_prepared_xacts` and `COMMIT PREPARED`/`ROLLBACK PREPARED` the stale ones (a stuck transaction manager is a common cause). If the workload legitimately needs more, raise `max_prepared_transactions` and restart. Setting it to 0 disables two-phase commit entirely.

## Example

*Illustrative* — no free prepared-transaction slots.

```sql
PREPARE TRANSACTION 'tx1';  -- maximum number of prepared transactions reached
```

## Related

- [invalid transaction termination](./invalid-transaction-termination.md)
- [invalid connection limit](./invalid-connection-limit.md)
