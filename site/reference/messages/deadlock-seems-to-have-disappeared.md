---
message: "deadlock seems to have disappeared"
slug: deadlock-seems-to-have-disappeared
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/lmgr/deadlock.c:243"
reproduced: false
---

# `deadlock seems to have disappeared`

## What it means

The deadlock detector saw a wait cycle, but by the time it went to resolve it the cycle was gone. It reports this and gives up on that pass rather than cancelling a transaction. The server logs it as a fatal-level note for that check.

## When it happens

It fires in a narrow race: the deadlock check found a cycle, but the involved locks changed — a transaction ended or a lock was released — before the detector could act, so there is no longer a deadlock to break.

## How to fix

This is usually benign and self-resolving: the deadlock cleared on its own. No action is normally needed. If it appears frequently alongside real deadlocks, treat it as a sign of heavy lock contention and apply the same measures — consistent lock ordering and shorter transactions.

## Example

*Illustrative* — the cycle cleared before resolution.

```text
LOG:  deadlock seems to have disappeared
```

## Related

- [deadlock detected](./deadlock-detected.md)
- [cursor is held from a previous transaction](./cursor-is-held-from-a-previous-transaction.md)
