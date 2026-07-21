---
message: "%s can only be used in transaction blocks"
slug: can-only-be-used-in-transaction-blocks
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_NO_ACTIVE_SQL_TRANSACTION
    code: "25P01"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3799"
  - "postgres/src/backend/access/transam/xact.c:4121"
  - "postgres/src/backend/access/transam/xact.c:4200"
  - "postgres/src/backend/access/transam/xact.c:4323"
  - "postgres/src/backend/access/transam/xact.c:4474"
  - "postgres/src/backend/access/transam/xact.c:4543"
  - "postgres/src/backend/access/transam/xact.c:4654"
reproduced: true
---

# `%s can only be used in transaction blocks`

## What it means

A command that requires an explicit, multi-statement transaction was run outside one. The placeholder is the command. Statements like `SAVEPOINT`, `RELEASE`, `ROLLBACK TO`, and `SET CONSTRAINTS ... DEFERRED` only make sense inside a `BEGIN ... COMMIT` block and are rejected in autocommit mode.

## When it happens

Issuing `SAVEPOINT`/`RELEASE`/`ROLLBACK TO SAVEPOINT` (or similar) as a standalone statement, without a preceding `BEGIN`. In autocommit each statement is its own transaction, so there is no block for these to operate on.

## How to fix

Wrap the command in an explicit transaction: `BEGIN; ... SAVEPOINT sp; ... COMMIT;`. These commands manage state within a transaction block, so they need one to exist. If your client runs in autocommit, start a transaction first.

## Example

*Reproduced* — captured from `reproducers/scenarios/50_txn_control_savepoints.sql`.

```sql
END AND CHAIN;
```

Produces:

```text
ERROR:  COMMIT AND CHAIN can only be used in transaction blocks
```

## Related

- [there is no transaction in progress](./there-is-no-transaction-in-progress.md)
- [current transaction is aborted](./current-transaction-is-aborted-commands-ignored-until-end-of-transaction-block.md)
