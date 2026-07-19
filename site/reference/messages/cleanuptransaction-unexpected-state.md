---
message: "CleanupTransaction: unexpected state %s"
slug: cleanuptransaction-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3070"
reproduced: false
---

# `CleanupTransaction: unexpected state %s`

## What it means

An internal guard fired: the transaction-cleanup routine ran while the transaction state machine was in a state it does not handle. The reported state should not be reachable at cleanup, so the server treats it as fatal.

## When it happens

It is reached from the transaction manager during cleanup. It reflects an internal state-machine inconsistency rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the server log around the message and the activity that preceded it, then report it. It points to a bug in transaction handling.

## Example

*Illustrative* — the internal guard firing.

```text
FATAL:  CleanupTransaction: unexpected state STARTED
```

## Related

- [clearing exported snapshot in wrong transaction state](./clearing-exported-snapshot-in-wrong-transaction-state.md)
- [close of before any relation was opened](./close-of-before-any-relation-was-opened.md)
