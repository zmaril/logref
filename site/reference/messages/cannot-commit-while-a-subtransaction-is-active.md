---
message: "cannot commit while a subtransaction is active"
slug: cannot-commit-while-a-subtransaction-is-active
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_TERMINATION
    code: "2D000"
call_sites:
  - "postgres/src/backend/executor/spi.c:255"
reproduced: false
---

# `cannot commit while a subtransaction is active`

## What it means

A procedure tried to commit the transaction while a subtransaction — a savepoint or PL/pgSQL exception block — was still open. Transaction control in a procedure applies to the top-level transaction, so it cannot run while a subtransaction is in progress.

## When it happens

It occurs when a procedure issues `COMMIT` inside a block that opened a savepoint or a PL/pgSQL `BEGIN ... EXCEPTION` section.

## How to fix

Complete or exit the subtransaction before committing. Move the `COMMIT` out of any exception-handling block so it runs at the top transaction level.

## Example

*Illustrative* — committing inside a subtransaction.

```text
ERROR:  cannot commit while a subtransaction is active
```

## Related

- [cannot commit while a portal is pinned](./cannot-commit-while-a-portal-is-pinned.md)
- [cannot commit during a parallel operation](./cannot-commit-during-a-parallel-operation.md)
