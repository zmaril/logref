---
message: "recovery has paused"
slug: recovery-has-paused
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:2917"
  - "postgres/src/backend/access/transam/xlogrecovery.c:4688"
reproduced: false
---

# `recovery has paused`

## What it means

A log message that WAL recovery has paused and will not apply further WAL until it is resumed.

## When it happens

It arises when recovery is paused — because `recovery_target_action = pause` was reached, or `pg_wal_replay_pause()` was called on a standby — leaving the server at a fixed point in the WAL stream.

## Is this a problem?

Resume with `pg_wal_replay_resume()` when you are ready for recovery to continue, or adjust the recovery target if the pause was reached at a target. The pause is deliberate; the server keeps serving read queries on a standby while paused.

## Example

*Illustrative* — recovery pausing.

```text
LOG:  recovery has paused
```

## Related

- [could not read WAL from timeline %u at %X/%08X: end of WAL at %X/%08X](./could-not-read-wal-from-timeline-at-end-of-wal-at.md)
- [canceling the wait for synchronous replication and terminating connection due to administrator command](./canceling-the-wait-for-synchronous-replication-and-terminating-connection-due.md)
