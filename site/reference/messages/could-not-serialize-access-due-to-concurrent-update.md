---
message: "could not serialize access due to concurrent update"
slug: could-not-serialize-access-due-to-concurrent-update
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/commands/trigger.c:3468"
  - "postgres/src/backend/executor/nodeLockRows.c:226"
  - "postgres/src/backend/executor/nodeModifyTable.c:411"
  - "postgres/src/backend/executor/nodeModifyTable.c:1976"
  - "postgres/src/backend/executor/nodeModifyTable.c:2890"
  - "postgres/src/backend/executor/nodeModifyTable.c:3096"
  - "postgres/src/backend/executor/nodeModifyTable.c:3827"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3312"
reproduced: false
---

# `could not serialize access due to concurrent update`

## What it means

A transaction was rolled back because a row it needed to update or lock was changed by another transaction that committed first. Under `REPEATABLE READ` or `SERIALIZABLE`, a write to a row that a concurrent committed transaction already modified cannot proceed without violating the isolation guarantee, so this transaction aborts.

## When it happens

Two transactions updating the same row concurrently under `REPEATABLE READ`/`SERIALIZABLE`; the second to reach the row after the first commits gets this. Also with `SELECT ... FOR UPDATE`/`FOR NO KEY UPDATE` on a row a concurrent transaction updated. It is expected under high write contention at these isolation levels.

## How to fix

This is a normal serialization failure — retry the transaction. Applications at `REPEATABLE READ`/`SERIALIZABLE` must catch `40001` and retry. To reduce the rate, shorten transactions and reduce hot-row contention, or use `READ COMMITTED` if its weaker guarantee is acceptable for the operation. Do not treat it as data corruption.

## Example

*Illustrative* — two REPEATABLE READ transactions updating one row.

```text
ERROR:  could not serialize access due to concurrent update
```

## Related

- [could not serialize access due to concurrent delete](./could-not-serialize-access-due-to-concurrent-delete.md)
- [could not serialize access due to read/write dependencies among transactions](./could-not-serialize-access-due-to-read-write-dependencies-among-transactions.md)
