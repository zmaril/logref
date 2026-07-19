---
message: "cannot have more than 2^32-1 subtransactions in a transaction"
slug: cannot-have-more-than-2-32-1-subtransactions-in-a-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:5495"
reproduced: false
---

# `cannot have more than 2^32-1 subtransactions in a transaction`

## What it means

A single transaction opened too many subtransactions. Subtransactions are numbered by a 32-bit command counter, and one transaction cannot hold more than 2^32-1 of them at once.

## When it happens

It occurs in workloads that open an enormous number of savepoints or PL/pgSQL exception blocks within one transaction without ever committing — each `SAVEPOINT` or exception-handled block is a subtransaction.

## How to fix

Reduce the number of subtransactions per transaction: commit periodically, release savepoints you no longer need, or restructure loops so they do not wrap every iteration in its own exception block. Batch the work across several transactions.

## Example

*Illustrative* — a transaction with too many subtransactions.

```text
ERROR:  cannot have more than 2^32-1 subtransactions in a transaction
```

## Related

- [cannot have more than 2^32-2 commands in a transaction](./cannot-have-more-than-2-32-2-commands-in-a-transaction.md)
- [cannot export a snapshot from a subtransaction](./cannot-export-a-snapshot-from-a-subtransaction.md)
