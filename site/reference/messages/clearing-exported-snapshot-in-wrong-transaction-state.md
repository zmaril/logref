---
message: "clearing exported snapshot in wrong transaction state"
slug: clearing-exported-snapshot-in-wrong-transaction-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:612"
reproduced: false
---

# `clearing exported snapshot in wrong transaction state`

## What it means

An internal guard fired: code tried to clear an exported snapshot while the transaction was not in the state that allows it. Snapshot export and clearing follow a fixed transaction lifecycle, so this state should not occur.

## When it happens

It is reached from snapshot-export bookkeeping used by tools that coordinate a consistent snapshot across sessions. It reflects an internal ordering issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any tooling that exports snapshots, and the server log, then report it. It points to a bug in the snapshot-export path.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  clearing exported snapshot in wrong transaction state
```

## Related

- [cleanuptransaction unexpected state](./cleanuptransaction-unexpected-state.md)
- [checksum mismatch for snapbuild state file is should be](./checksum-mismatch-for-snapbuild-state-file-is-should-be.md)
