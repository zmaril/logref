---
message: "cannot PREPARE while holding both session-level and transaction-level locks on the same object"
slug: cannot-prepare-while-holding-both-session-level-and-transaction-level-locks-on
passthrough: false
api: [ereport]
level: [ERROR, PANIC]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:3462"
  - "postgres/src/backend/storage/lmgr/lock.c:3530"
  - "postgres/src/backend/storage/lmgr/lock.c:3646"
reproduced: false
---

# `cannot PREPARE while holding both session-level and transaction-level locks on the same object`

## What it means

`PREPARE TRANSACTION` (two-phase commit) was attempted while the session held both a session-level and a transaction-level advisory or object lock on the same object. A prepared transaction must hand its locks to the prepared-transaction state, which cannot represent a mix of session- and transaction-scoped locks on one object, so it refuses.

## When it happens

Preparing a transaction after taking a session-level advisory lock (`pg_advisory_lock`) and also a transaction-level lock on the same key within the transaction being prepared.

## How to fix

Release the session-level lock before `PREPARE TRANSACTION`, or avoid holding both scopes on the same object inside a transaction you intend to prepare. Use transaction-level advisory locks (`pg_advisory_xact_lock`) consistently if the work will be part of a two-phase commit.

## Example

*Illustrative* — preparing with mixed lock scopes.

```text
ERROR:  cannot PREPARE while holding both session-level and transaction-level locks on the same object
```

## Related

- [savepoint does not exist](./savepoint-does-not-exist.md)
- [could not obtain lock on relation](./could-not-obtain-lock-on-relation-da8ac5.md)
