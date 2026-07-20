---
message: "UserAbortTransactionBlock: unexpected state %s"
slug: useraborttransactionblock-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4296"
  - "postgres/src/backend/access/transam/xact.c:4305"
  - "postgres/src/backend/access/transam/xact.c:4359"
reproduced: false
---

# `UserAbortTransactionBlock: unexpected state %s`

## What it means

Internal error. The routine that handles a user `ROLLBACK` found the transaction in a state it does not expect. It is a consistency check on the transaction state machine, raised at FATAL because an inconsistent transaction state is unsafe to continue from.

## When it happens

It should not occur through normal transaction control. Reaching it points to an internal inconsistency in transaction-state handling rather than to your `ROLLBACK` usage as such.

## How to fix

Treat it as an internal bug. The FATAL ends the session; capture the surrounding log context and the sequence of transaction commands leading to it, and report it. There is no application-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — raised by the transaction state machine on ROLLBACK.

```text
FATAL:  UserAbortTransactionBlock: unexpected state STARTED
```

## Related

- [rollbacktosavepoint unexpected state](./rollbacktosavepoint-unexpected-state.md)
- [there is no transaction in progress](./there-is-no-transaction-in-progress.md)
