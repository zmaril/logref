---
message: "commit_lsn is not set in commit prepared message"
slug: commit-lsn-is-not-set-in-commit-prepared-message
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:278"
reproduced: false
---

# `commit_lsn is not set in commit prepared message`

## What it means

A logical-replication `COMMIT PREPARED` protocol message arrived without its commit LSN set. The commit LSN is required to apply the prepared transaction, so the message is rejected. This is an internal protocol check.

## When it happens

It fires on the subscriber (or output-plugin consumer) when decoding a two-phase commit stream and the commit-prepared message is missing its LSN field.

## How to fix

This points to a replication protocol inconsistency, not a user setting. Check that publisher and subscriber are compatible versions and that the stream is not corrupted; capture the surrounding replication logs and report it if it persists.

## Example

*Illustrative* — a commit-prepared message without a commit LSN.

```text
ERROR:  commit_lsn is not set in commit prepared message
```

## Related

- [could not alter replication slot](./could-not-alter-replication-slot.md)
- [corrupted two-phase state file for transaction of epoch](./corrupted-two-phase-state-file-for-transaction-of-epoch.md)
