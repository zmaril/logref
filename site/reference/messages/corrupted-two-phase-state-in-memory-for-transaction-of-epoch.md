---
message: "corrupted two-phase state in memory for transaction %u of epoch %u"
slug: corrupted-two-phase-state-in-memory-for-transaction-of-epoch
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:2276"
reproduced: false
---

# `corrupted two-phase state in memory for transaction %u of epoch %u`

## What it means

The in-memory record for a prepared (two-phase) transaction was found inconsistent. The tracked state does not match what is expected, indicating memory corruption or a serious bug affecting two-phase commit.

## When it happens

It fires while processing prepared transactions when the in-memory two-phase state for a transaction is invalid.

## How to fix

This is an internal corruption signal, not a user setting. Note the surrounding activity, check system memory health, and report it. Restarting reloads two-phase state from disk; if disk state is also bad, restore from a consistent backup.

## Example

*Illustrative* — corrupted in-memory two-phase state.

```text
ERROR:  corrupted two-phase state in memory for transaction 8912 of epoch 3
```

## Related

- [corrupted two-phase state file for transaction of epoch](./corrupted-two-phase-state-file-for-transaction-of-epoch.md)
- [corrupted hashtable](./corrupted-hashtable.md)
