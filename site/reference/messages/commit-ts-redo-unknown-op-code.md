---
message: "commit_ts_redo: unknown op code %u"
slug: commit-ts-redo-unknown-op-code
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/commit_ts.c:1025"
reproduced: false
---

# `commit_ts_redo: unknown op code %u`

## What it means

During crash recovery or replication, the commit-timestamp WAL-replay routine encountered a record whose operation code it does not recognize. It cannot replay an unknown record type, so it stops with a PANIC. This usually signals WAL corruption or a version mismatch.

## When it happens

It fires while replaying `commit_ts` WAL records at startup recovery or on a standby, when a record's op code is not one of the expected values.

## How to fix

Treat this as possible WAL corruption or a mismatched binary. Ensure the server binary matches the data directory's version, verify storage integrity, and restore from a known-good backup if the WAL is damaged. Do not ignore it — recovery cannot proceed past the bad record.

## Example

*Illustrative* — an unrecognized commit-timestamp WAL record.

```text
PANIC:  commit_ts_redo: unknown op code 42
```

## Related

- [clog_redo unknown op code](./clog-redo-unknown-op-code.md)
- [concurrent write-ahead log activity while database system is shutting down](./concurrent-write-ahead-log-activity-while-database-system-is-shutting-down.md)
