---
message: "cannot have more than 2^32-2 commands in a transaction"
slug: cannot-have-more-than-2-32-2-commands-in-a-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:1154"
reproduced: false
---

# `cannot have more than 2^32-2 commands in a transaction`

## What it means

A single transaction ran too many commands. Postgres numbers commands within a transaction with a 32-bit counter so later commands can see the effects of earlier ones, and that counter cannot exceed 2^32-2.

## When it happens

It occurs in a long-lived transaction that issues billions of individual statements — for example a loop that executes one statement per iteration across an enormous data set without committing.

## How to fix

Commit periodically so the command counter resets with each new transaction. Batch statements (multi-row `INSERT`, set-based `UPDATE`) instead of running one command per row, and split very large jobs across transactions.

## Example

*Illustrative* — a transaction with too many commands.

```text
ERROR:  cannot have more than 2^32-2 commands in a transaction
```

## Related

- [cannot have more than 2^32-1 subtransactions in a transaction](./cannot-have-more-than-2-32-1-subtransactions-in-a-transaction.md)
- [cannot insert multiple commands into a prepared statement](./cannot-insert-multiple-commands-into-a-prepared-statement.md)
