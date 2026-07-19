---
message: "EndTransactionBlock: unexpected state %s"
slug: endtransactionblock-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4152"
  - "postgres/src/backend/access/transam/xact.c:4159"
  - "postgres/src/backend/access/transam/xact.c:4177"
  - "postgres/src/backend/access/transam/xact.c:4186"
  - "postgres/src/backend/access/transam/xact.c:4236"
reproduced: false
---

# `EndTransactionBlock: unexpected state %s`

## What it means

Internal error. The transaction state machine's commit path (`EndTransactionBlock`) was entered while the backend was in a transaction state it does not expect there. The placeholder is the state name. It is a consistency check on the transaction-block state machine, and it fires at `FATAL`.

## When it happens

It should never occur through normal SQL. Reaching it indicates a bug in transaction-control handling — sometimes triggered by an extension driving transactions in unusual ways — or corrupted backend state.

## How to fix

Treat it as an internal bug. If it correlates with an extension that manages transactions or subtransactions, suspect that. Capture the sequence of statements and server log around the failure and report it.

## Example

*Illustrative* — emitted internally by transaction control.

```text
FATAL:  EndTransactionBlock: unexpected state STARTED
```

## Related

- [can only be used in transaction blocks](./can-only-be-used-in-transaction-blocks.md)
- [invalid tuplestore state](./invalid-tuplestore-state.md)
