---
message: "could not write an additional WAL record: %s"
slug: could-not-write-an-additional-wal-record
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:938"
reproduced: false
---

# `could not write an additional WAL record: %s`

## What it means

`pg_createsubscriber` could not write an extra write-ahead log record it needs on the target. The trailing text is the reason. The tool writes a marker record while converting a standby into a subscriber.

## When it happens

It fires during `pg_createsubscriber`, in the step that emits an additional WAL record on the target server, when that write fails.

## How to fix

Check the surrounding output for the underlying cause — the target server not accepting writes, a connection problem, or a storage issue. Make sure the target is in the expected state for conversion and reachable, then rerun the tool from a clean starting point.

## Example

*Illustrative* — writing the extra WAL record failed.

```text
pg_createsubscriber: error: could not write an additional WAL record: connection failure
```

## Related

- [could not reset WAL on subscriber](./could-not-reset-wal-on-subscriber.md)
- [could not set replication progress for subscription](./could-not-set-replication-progress-for-subscription.md)
