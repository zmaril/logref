---
message: "concurrent write-ahead log activity while database system is shutting down"
slug: concurrent-write-ahead-log-activity-while-database-system-is-shutting-down
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7776"
reproduced: false
---

# `concurrent write-ahead log activity while database system is shutting down`

## What it means

During a shutdown checkpoint, the server detected new WAL being written after it expected all activity to have stopped. Something generated WAL when nothing should have, so it stops with a PANIC to avoid an inconsistent shutdown. This is an internal safety check.

## When it happens

It fires in the checkpointer at shutdown when the WAL insert position advances after the point where the server assumed all backends had finished.

## How to fix

This indicates an internal timing or extension issue rather than a routine configuration problem. Note any custom background workers or extensions that might write WAL late in shutdown, and report the occurrence with logs; recovery on the next start will reconcile the WAL, but the underlying cause should be investigated.

## Example

*Illustrative* — late WAL activity during shutdown.

```text
PANIC:  concurrent write-ahead log activity while database system is shutting down
```

## Related

- [commit_ts_redo unknown op code](./commit-ts-redo-unknown-op-code.md)
- [could not close bootstrap write-ahead log file](./could-not-close-bootstrap-write-ahead-log-file.md)
