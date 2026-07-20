---
message: "cannot prevent transaction chain"
slug: cannot-prevent-transaction-chain
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3736"
reproduced: false
---

# `cannot prevent transaction chain`

## What it means

An internal guard fired during transaction commit processing: a command that must not run in a chained transaction reached a point where the chain could not be prevented. It marks an inconsistency in the transaction-chaining machinery.

## When it happens

It is reached in the commit path when transaction-control state is unexpected. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the command sequence and any procedural code driving transaction control and report it, since this state should not arise in normal processing.

## Example

*Illustrative* — an unexpected transaction-chain state.

```text
FATAL:  cannot prevent transaction chain
```

## Related

- [cannot run inside a transaction block](./cannot-run-inside-a-transaction-block.md)
- [cannot roll back while a subtransaction is active](./cannot-roll-back-while-a-subtransaction-is-active.md)
