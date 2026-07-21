---
message: "%s: current transaction is aborted"
slug: current-transaction-is-aborted
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/large_obj.c:84"
reproduced: false
---

# `%s: current transaction is aborted`

## What it means

A `psql` large-object operation could not proceed because the current transaction is in the aborted state. Once a statement in a transaction fails, the whole transaction is aborted until it is rolled back. The leading placeholder names the operation.

## When it happens

It happens when you run a large-object command in `psql` after an earlier error in the same transaction block, before issuing `ROLLBACK`.

## How to fix

End the failed transaction with `ROLLBACK` (or roll back to a savepoint) and start again. Inside a transaction block, no further work runs until the aborted transaction is cleared. Fix the statement that failed first, then retry.

## Example

*Illustrative* — a large-object command in an aborted transaction.

```text
\lo_import: current transaction is aborted
```

## Related

- [\crosstabview: statement did not return a result set](./crosstabview-statement-did-not-return-a-result-set.md)
- [cursor is held from a previous transaction](./cursor-is-held-from-a-previous-transaction.md)
