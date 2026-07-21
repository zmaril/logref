---
message: "could not serialize access due to concurrent delete"
slug: could-not-serialize-access-due-to-concurrent-delete
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/commands/trigger.c:3476"
  - "postgres/src/backend/executor/nodeLockRows.c:235"
  - "postgres/src/backend/executor/nodeModifyTable.c:2066"
  - "postgres/src/backend/executor/nodeModifyTable.c:2981"
  - "postgres/src/backend/executor/nodeModifyTable.c:3112"
  - "postgres/src/backend/executor/nodeModifyTable.c:3807"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3305"
reproduced: false
---

# `could not serialize access due to concurrent delete`

## What it means

A transaction was rolled back because a row it needed to update or lock was deleted by another transaction that committed first. Under `REPEATABLE READ`/`SERIALIZABLE`, proceeding would break the isolation guarantee, so this transaction aborts.

## When it happens

A transaction at `REPEATABLE READ`/`SERIALIZABLE` (or a `SELECT ... FOR UPDATE`) touches a row that a concurrent committed transaction deleted. It is the delete counterpart of the concurrent-update serialization failure and is expected under contention.

## How to fix

This is a normal serialization failure — retry the transaction. Catch `40001` and retry at the application level. To reduce it, shorten transactions and reduce contention on rows that are concurrently deleted, or use `READ COMMITTED` where its semantics suffice. It is not corruption.

## Example

*Illustrative* — updating a row a concurrent transaction deleted.

```text
ERROR:  could not serialize access due to concurrent delete
```

## Related

- [could not serialize access due to concurrent update](./could-not-serialize-access-due-to-concurrent-update.md)
- [could not serialize access due to read/write dependencies among transactions](./could-not-serialize-access-due-to-read-write-dependencies-among-transactions.md)
