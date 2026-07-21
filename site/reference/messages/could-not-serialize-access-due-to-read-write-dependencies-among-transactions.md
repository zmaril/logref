---
message: "could not serialize access due to read/write dependencies among transactions"
slug: could-not-serialize-access-due-to-read-write-dependencies-among-transactions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/storage/lmgr/predicate.c:3928"
  - "postgres/src/backend/storage/lmgr/predicate.c:3964"
  - "postgres/src/backend/storage/lmgr/predicate.c:3997"
  - "postgres/src/backend/storage/lmgr/predicate.c:4005"
  - "postgres/src/backend/storage/lmgr/predicate.c:4044"
  - "postgres/src/backend/storage/lmgr/predicate.c:4274"
  - "postgres/src/backend/storage/lmgr/predicate.c:4593"
  - "postgres/src/backend/storage/lmgr/predicate.c:4605"
  - "postgres/src/backend/storage/lmgr/predicate.c:4652"
  - "postgres/src/backend/storage/lmgr/predicate.c:4688"
reproduced: false
---

# `could not serialize access due to read/write dependencies among transactions`

## What it means

A `SERIALIZABLE` transaction was rolled back to preserve serializability. Postgres's Serializable Snapshot Isolation detected a pattern of read/write dependencies among concurrent transactions that could produce a result no serial ordering would allow, so it aborted one to keep the outcome correct.

## When it happens

Under `SERIALIZABLE` isolation, when concurrent transactions read and write overlapping data in a way that forms a dangerous dependency cycle. It is expected and normal at high concurrency; the more contention, the more often it fires. The `40001` SQLSTATE marks it as a serialization failure.

## How to fix

This is not a bug — retry the transaction. Serialization failures are the expected cost of `SERIALIZABLE`, and applications using that level must catch `40001` and retry the whole transaction (usually with a small backoff). To reduce the rate, shorten transactions, reduce overlap between them, or add explicit locking where a hot conflict is known. Do not lower the isolation level unless the weaker guarantee is acceptable.

## Example

*Illustrative* — two serializable transactions with a read/write dependency.

```text
ERROR:  could not serialize access due to read/write dependencies among transactions
DETAIL:  Reason code: Canceled on identification as a pivot, during commit attempt.
HINT:  The transaction might succeed if retried.
```

## Related

- [could not serialize access due to concurrent update](./could-not-serialize-access-due-to-concurrent-update.md)
- [could not serialize access due to concurrent delete](./could-not-serialize-access-due-to-concurrent-delete.md)
