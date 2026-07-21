---
message: "could not set replication progress for subscription \"%s\": %s"
slug: could-not-set-replication-progress-for-subscription
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2122"
reproduced: false
---

# `could not set replication progress for subscription "%s": %s`

## What it means

`pg_createsubscriber` could not set the starting replication position for a subscription on the target. The placeholder is the subscription name and the trailing text is the reason. Setting the origin tells the new subscriber where to begin applying changes.

## When it happens

It fires during `pg_createsubscriber` in the step that records each subscription's replication origin, when that step fails against the target database.

## How to fix

Check the surrounding output for the underlying failure — a connection problem to the target, or a subscription that is not in the expected state. Make sure the target is the freshly promoted subscriber and reachable. Fix the reported cause and rerun the conversion.

## Example

*Illustrative* — setting the origin failed.

```text
pg_createsubscriber: error: could not set replication progress for subscription "sub1": connection failure
```

## Related

- [could not reset WAL on subscriber](./could-not-reset-wal-on-subscriber.md)
- [could not write an additional WAL record](./could-not-write-an-additional-wal-record.md)
