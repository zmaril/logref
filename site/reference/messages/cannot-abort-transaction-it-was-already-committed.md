---
message: "cannot abort transaction %u, it was already committed"
slug: cannot-abort-transaction-it-was-already-committed
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:2462"
  - "postgres/src/backend/access/transam/xact.c:1835"
reproduced: false
---

# `cannot abort transaction %u, it was already committed`

## What it means

PANIC-level internal error. Transaction-management code was asked to abort a transaction whose commit record has already been written. The placeholder is the transaction ID. Once a transaction is durably committed it cannot be un-committed, so the system stops rather than corrupt its own state.

## When it happens

It should not occur in normal operation. Reaching it points to a serious internal inconsistency in transaction bookkeeping — a bug, or memory or storage corruption of the transaction state.

## How to fix

Treat it as a critical internal fault. The backend PANICs and the server restarts. Preserve the server log around the event, note anything unusual about the hardware or storage, and report it. If it recurs, check memory and storage integrity, since silent corruption can produce it.

## Example

*Illustrative* — emitted internally when an already-committed transaction is aborted.

```text
PANIC:  cannot abort transaction 48213, it was already committed
```

## Related

- [CommitTransactionCommand: unexpected state](./committransactioncommand-unexpected-state.md)
- [cannot make new WAL entries during recovery](./cannot-make-new-wal-entries-during-recovery.md)
