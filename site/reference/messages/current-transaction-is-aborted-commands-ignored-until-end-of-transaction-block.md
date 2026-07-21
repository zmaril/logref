---
message: "current transaction is aborted, commands ignored until end of transaction block"
slug: current-transaction-is-aborted-commands-ignored-until-end-of-transaction-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_IN_FAILED_SQL_TRANSACTION
    code: "25P02"
call_sites:
  - "postgres/src/backend/replication/walsender.c:2210"
  - "postgres/src/backend/tcop/fastpath.c:206"
  - "postgres/src/backend/tcop/postgres.c:1163"
  - "postgres/src/backend/tcop/postgres.c:1530"
  - "postgres/src/backend/tcop/postgres.c:1791"
  - "postgres/src/backend/tcop/postgres.c:2313"
  - "postgres/src/backend/tcop/postgres.c:2781"
  - "postgres/src/backend/tcop/postgres.c:2857"
reproduced: false
---

# `current transaction is aborted, commands ignored until end of transaction block`

## What it means

An earlier statement in the current transaction raised an error, so the transaction is in the aborted state. Postgres refuses every subsequent command until the transaction block is ended (with `ROLLBACK`, or `COMMIT` which also rolls back). No further work can happen in this transaction.

## When it happens

Any error inside an explicit `BEGIN ... COMMIT` block followed by more statements — the failing statement aborts the transaction, and everything after it gets this until you roll back. Common when a script does not check for errors between statements.

## How to fix

Issue `ROLLBACK` (or `ROLLBACK TO SAVEPOINT` if you set a savepoint before the failing statement) to leave the aborted state, then re-run or fix the offending statement. To let a transaction continue past a possible error, wrap the risky statement in a `SAVEPOINT` and roll back to it on failure. In application code, handle the first error rather than sending more statements.

## Example

*Illustrative* — a statement after an error in a transaction.

```sql
BEGIN;
SELECT 1/0;        -- errors
SELECT 1;          -- ignored
```

Produces:

```text
ERROR:  current transaction is aborted, commands ignored until end of transaction block
```

## Related

- [there is no transaction in progress](./there-is-no-transaction-in-progress.md)
- [%s can only be used in transaction blocks](./can-only-be-used-in-transaction-blocks.md)
