---
message: "RollbackToSavepoint: unexpected state %s"
slug: rollbacktosavepoint-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4684"
  - "postgres/src/backend/access/transam/xact.c:4721"
  - "postgres/src/backend/access/transam/xact.c:4733"
reproduced: false
---

# `RollbackToSavepoint: unexpected state %s`

## What it means

Internal error. The transaction machinery reached the rollback-to-savepoint path while the transaction was in a state that path does not expect. It is a consistency check on the transaction state machine, raised at FATAL because a broken transaction state is unsafe to continue from.

## When it happens

It should not occur through normal transaction control. Reaching it points to an internal inconsistency in transaction-state handling, not to your `ROLLBACK TO SAVEPOINT` usage as such.

## How to fix

Treat it as an internal bug. The FATAL ends the session; capture the surrounding log context and the sequence of transaction commands that led to it, and report it. There is no application-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — raised by the transaction state machine.

```text
FATAL:  RollbackToSavepoint: unexpected state STARTED
```

## Related

- [useraborttransactionblock unexpected state](./useraborttransactionblock-unexpected-state.md)
- [definesavepoint unexpected state](./definesavepoint-unexpected-state.md)
