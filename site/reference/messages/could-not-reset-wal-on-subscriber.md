---
message: "could not reset WAL on subscriber: %s"
slug: could-not-reset-wal-on-subscriber
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:772"
reproduced: false
---

# `could not reset WAL on subscriber: %s`

## What it means

`pg_createsubscriber` could not reset the write-ahead log on the target cluster it is converting into a subscriber. The trailing text is the reason. Resetting WAL is part of turning a physical standby into a logical subscriber.

## When it happens

It fires during `pg_createsubscriber`, in the step that runs `pg_resetwal` against the target's data directory, when that step fails.

## How to fix

Check the surrounding output for the underlying `pg_resetwal` failure — a running server on the target, a permission problem, or an inconsistent data directory. The target must be shut down cleanly and owned by the user running the tool. Fix the reported cause and rerun the conversion from a clean state.

## Example

*Illustrative* — the WAL reset step failed.

```text
pg_createsubscriber: error: could not reset WAL on subscriber: exit code 1
```

## Related

- [could not write an additional WAL record](./could-not-write-an-additional-wal-record.md)
- [could not set replication progress for subscription](./could-not-set-replication-progress-for-subscription.md)
