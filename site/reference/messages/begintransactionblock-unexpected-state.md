---
message: "BeginTransactionBlock: unexpected state %s"
slug: begintransactionblock-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4027"
reproduced: false
---

# `BeginTransactionBlock: unexpected state %s`

## What it means

The routine that begins a transaction block found the transaction in a state where `BEGIN` cannot proceed. The placeholder names the current state. It guards the transaction state machine.

## When it happens

It is an internal guard. It would surface from a bug in code that drives transaction control out of the normal order, not from a plain `BEGIN`.

## How to fix

This points at a defect in extension or protocol-level code managing transactions. Record the sequence of transaction-control commands and any extensions in use, and report it with the server version.

## Example

*Illustrative* — BEGIN from an unexpected state.

```text
FATAL:  BeginTransactionBlock: unexpected state STARTED
```

## Related

- [begininternalsubtransaction unexpected state](./begininternalsubtransaction-unexpected-state.md)
- [both subquery and values rtes in insert](./both-subquery-and-values-rtes-in-insert.md)
