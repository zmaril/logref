---
message: "invalid transaction termination"
slug: invalid-transaction-termination
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_TERMINATION
    code: "2D000"
call_sites:
  - "postgres/src/backend/executor/spi.c:240"
  - "postgres/src/backend/executor/spi.c:340"
reproduced: false
---

# `invalid transaction termination`

## What it means

A `COMMIT` or `ROLLBACK` was attempted from a context where the transaction cannot be ended that way. Only top-level procedure/`DO` execution may control transactions; nested or disallowed contexts cannot.

## When it happens

It arises when a procedure called with `CALL` issues `COMMIT`/`ROLLBACK` while inside a context that forbids it — for example when the procedure was invoked from a function, from a query, or within an explicit transaction block that pins the transaction, or from a trigger.

## How to fix

Only manage transactions in procedures invoked directly by `CALL` at the top level, not from inside functions, queries, or triggers. Remove the `COMMIT`/`ROLLBACK` from contexts that cannot control the transaction, or restructure so the transaction control happens at the top level.

## Example

*Illustrative* — committing where it is not allowed.

```sql
SELECT my_proc_that_commits();  -- transaction control not allowed from a query
```

## Related

- [into used with a command that cannot return data](./into-used-with-a-command-that-cannot-return-data.md)
- [invalid transaction ID in streamed replication transaction](./invalid-transaction-id-in-streamed-replication-transaction.md)
