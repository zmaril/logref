---
message: "CommitTransactionCommand: unexpected state %s"
slug: committransactioncommand-unexpected-state
passthrough: false
api: [elog]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3246"
  - "postgres/src/backend/access/transam/xact.c:3412"
reproduced: false
---

# `CommitTransactionCommand: unexpected state %s`

## What it means

Internal error. The transaction state machine reached `CommitTransactionCommand` while in a state it does not expect there. The placeholder names the state. It is a consistency check on the transaction lifecycle; at FATAL level it aborts the backend.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in transaction state management — a bug, or an unexpected interaction between a command and the surrounding transaction.

## How to fix

Treat it as an internal fault. Capture the server log and the sequence of commands (especially any unusual transaction control, savepoints, or errors preceding it) and report it. There is no reliable user-side workaround.

## Example

*Illustrative* — emitted internally by the transaction state machine.

```text
ERROR:  CommitTransactionCommand: unexpected state STARTED
```

## Related

- [cannot abort transaction it was already committed](./cannot-abort-transaction-it-was-already-committed.md)
- [consistency check on SPI tuple count failed](./consistency-check-on-spi-tuple-count-failed.md)
