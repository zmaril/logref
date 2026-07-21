---
message: "savepoint \"%s\" does not exist"
slug: savepoint-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_E_INVALID_SPECIFICATION
    code: "3B001"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4536"
  - "postgres/src/backend/access/transam/xact.c:4587"
  - "postgres/src/backend/access/transam/xact.c:4647"
  - "postgres/src/backend/access/transam/xact.c:4696"
reproduced: true
---

# `savepoint "%s" does not exist`

## What it means

A `RELEASE SAVEPOINT` or `ROLLBACK TO SAVEPOINT` named a savepoint that is not currently established in the transaction. The placeholder is the name. Savepoints exist only within their transaction and only until released or rolled back past; naming one that was never set, or already gone, is an error.

## When it happens

Referencing a savepoint that was misspelled, never created, already released, or destroyed because the transaction rolled back to an earlier savepoint — or trying to use a savepoint after the transaction ended.

## How to fix

Establish the savepoint with `SAVEPOINT name` before releasing or rolling back to it, and check the spelling. Remember that rolling back to an earlier savepoint invalidates the ones created after it, and that savepoints do not survive across transactions.

## Example

*Reproduced* — captured from `reproducers/scenarios/50_txn_control_savepoints.sql`.

```sql
RELEASE SAVEPOINT outer_sp;
```

Produces:

```text
ERROR:  savepoint "outer_sp" does not exist
```

## Related

- [cannot PREPARE while holding both session-level and transaction-level locks on](./cannot-prepare-while-holding-both-session-level-and-transaction-level-locks-on.md)
- [schema does not exist](./schema-does-not-exist.md)
