---
message: "cannot roll back while a subtransaction is active"
slug: cannot-roll-back-while-a-subtransaction-is-active
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_TERMINATION
    code: "2D000"
call_sites:
  - "postgres/src/backend/executor/spi.c:346"
reproduced: false
---

# `cannot roll back while a subtransaction is active`

## What it means

SPI was asked to roll back the transaction while a subtransaction was still active. Transaction control through SPI requires the subtransaction stack to be unwound first, so the rollback is refused.

## When it happens

It occurs in procedural code (PL/pgSQL or an extension using SPI) that calls `ROLLBACK` while inside an exception block or an open savepoint, which runs as a subtransaction.

## How to fix

Exit or resolve the subtransaction before rolling back — leave the exception-handling block, or release the savepoint — then perform the rollback at the top level. Do not issue transaction control from inside a subtransaction.

## Example

*Illustrative* — rollback with a subtransaction open.

```text
ERROR:  cannot roll back while a subtransaction is active
```

## Related

- [cannot perform transaction commands inside a cursor loop that is not read-only](./cannot-perform-transaction-commands-inside-a-cursor-loop-that-is-not-read-only.md)
- [cannot rollback to savepoints during a parallel operation](./cannot-rollback-to-savepoints-during-a-parallel-operation.md)
