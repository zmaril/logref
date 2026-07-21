---
message: "could not locate backup block with ID %d in WAL record"
slug: could-not-locate-backup-block-with-id-in-wal-record
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogreader.c:2020"
  - "postgres/src/backend/access/transam/xlogreader.c:2023"
reproduced: false
---

# `could not locate backup block with ID %d in WAL record`

## What it means

Internal error while decoding a WAL record. A redo routine asked for a registered backup block by ID and the WAL reader did not find one with that ID in the record. The placeholder is the block ID.

## When it happens

It fires during recovery or WAL decoding over a record whose registered-block bookkeeping is inconsistent with what the redo code expects. It can accompany WAL corruption.

## How to fix

This is a consistency check. If it appears during recovery, treat it as possible WAL damage: check storage health, and if you have a good base backup plus later WAL, consider restoring. Capture the WAL LSN and report a reproducible case.

## Example

*Illustrative* — a redo routine requested a missing backup block.

```text
ERROR:  could not locate backup block with ID 1 in WAL record
```

## Related

- [could not read WAL record at](./could-not-read-wal-record-at-9b93fd.md)
- [could not read WAL at](./could-not-read-wal-at-b48b38.md)
